// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // All users collection
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    Map<String, String> fieldTranslations = {
      "username": "username",
      "bio": "bio",
    };

    String translatedField = fieldTranslations[field] ?? field;

    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $translatedField",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter $translatedField",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    // Update the field in the database
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OldProfilePage()),
    );
  }

  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String fileName = currentUser.email!;

    try {
      await FirebaseStorage.instance
          .ref('profile_pictures/$fileName')
          .putFile(imageFile);

      String downloadURL = await FirebaseStorage.instance
          .ref('profile_pictures/$fileName')
          .getDownloadURL();

      await usersCollection
          .doc(currentUser.email)
          .update({'profilePicUrl': downloadURL});
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading profile picture: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                const SizedBox(height: 40),
                // Settings icon, profile text, and currency display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Settings button with border and new background color
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xffDADDD8), // New background color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings, color: Colors.black),
                          onPressed: openSettings,
                        ),
                      ),
                      // Profile text
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Currency display with border and new background color
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xffDADDD8), // New background color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "1000₵",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Icon(Icons.add, color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Profile picture
                GestureDetector(
                  onTap: uploadProfilePicture,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(userData["profilePicUrl"] ??
                        "https://via.placeholder.com/225"),
                  ),
                ),
                const SizedBox(height: 10),
                // User name
                Text(
                  userData["username"] ?? "Unknown User",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                // Buttons
                ProfileButton(title: 'Calendar', onPressed: () {}),
                ProfileButton(title: 'Support', onPressed: () {}),
                ProfileButton(title: 'Pro-version', onPressed: () {}),
                ProfileButton(title: 'Moderation', onPressed: () {}),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ProfileButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xffDADDD8), // Updated background color
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class OldProfilePage extends StatefulWidget {
  const OldProfilePage({super.key});

  @override
  State<OldProfilePage> createState() => _OldProfilePageState();
}

class _OldProfilePageState extends State<OldProfilePage> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // All users collection
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    Map<String, String> fieldTranslations = {
      "username": "username",
      "bio": "bio",
    };

    String translatedField = fieldTranslations[field] ?? field;

    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $translatedField",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter $translatedField",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    // Update the field in the database
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

// Updated method to select an image using ImagePicker
  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String fileName = currentUser.email!;

    try {
      // Upload the image to Firebase Storage
      await FirebaseStorage.instance
          .ref('profile_pictures/$fileName')
          .putFile(imageFile);

      // Get the URL of the uploaded image
      String downloadURL = await FirebaseStorage.instance
          .ref('profile_pictures/$fileName')
          .getDownloadURL();

      // Update the profile URL in the Firestore database
      await usersCollection
          .doc(currentUser.email)
          .update({'profilePicUrl': downloadURL});

      // Update the state to reflect the new profile picture
      setState(() {});

      // Notify the user of successful upload
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture uploaded successfully!'),
        ),
      );
    } catch (e) {
      // Print error in debug mode
      if (kDebugMode) {
        print("Error uploading profile picture: $e");
      }
      // Notify the user of an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading profile picture. Please try again.'),
        ),
      );
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: uploadProfilePicture,
              icon: const Icon(Icons.camera_alt),
            ),
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
          ],
          title:
              Text("User Profile", style: TextStyle(color: Colors.grey[300])),
          backgroundColor: Colors.grey[900],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    // Profile pic
                    const Icon(
                      Icons.person,
                      size: 100,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    // User email
                    Text(currentUser.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700])),

                    const SizedBox(
                      height: 50,
                    ),
                    // User details
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("User Details",
                          style: TextStyle(color: Colors.grey[600])),
                    ),

                    // Username
                    MyTextBox(
                      sectionName: "Username",
                      text: userData["username"],
                      onPressed: () => editField("username"),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Bio
                    MyTextBox(
                      sectionName: "Bio",
                      text: userData["bio"],
                      onPressed: () => editField("bio"),
                    ),

                    // User posts
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("User Posts",
                          style: TextStyle(color: Colors.grey[600])),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class MyTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.sectionName,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section name
                Text(
                  sectionName,
                  style: TextStyle(color: Colors.grey[500]),
                ),

                const SizedBox(
                  height: 8,
                ),

                // Text
                Text(text),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
