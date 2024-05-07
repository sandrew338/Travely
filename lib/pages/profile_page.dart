import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travely/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    Map<String, String> fieldTranslations = {
      "username": "ім'я користувача",
      "bio": "опис",
    };

    String translatedField = fieldTranslations[field] ?? field;

    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Редагувати $translatedField",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Введіть $translatedField",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Відмінити",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Зберегти",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    // update the field in the database

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
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
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
          ],
          title: Text("Мій профіль", style: TextStyle(color: Colors.grey[300])),
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

                    //profile pic

                    const Icon(
                      Icons.person,
                      size: 100,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    //user email
                    Text(currentUser.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700])),

                    const SizedBox(
                      height: 50,
                    ),
                    //user details
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Мої дані",
                          style: TextStyle(color: Colors.grey[600])),
                    ),

                    //username

                    MyTextBox(
                      sectionName: "Ім'я користувача",
                      text: userData["username"],
                      onPressed: () => editField("username"),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //bio

                    MyTextBox(
                      sectionName: "Опис",
                      text: userData["bio"],
                      onPressed: () => editField("bio"),
                    ),

                    //user posts

                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Мої маршрути",
                          style: TextStyle(color: Colors.grey[600])),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Помилка${snapshot.error}"),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            })); //SvgPicture.asset("assets/images/selected/time_past.svg")
  }
}
