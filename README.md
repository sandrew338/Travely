Travely
Travely is a platform for discovering interesting interactive tours. Residents and visitors of the city who want to spend their time actively can generate walking routes in our application. It is mainly aimed at tourists who want to visit as many interesting places as possible within a limited time.

Introduction
Have you ever arrived in a city and couldn't find interesting places to visit?
How often have you felt tired from endlessly searching for interesting routes through the city on Google?
How often did the route suggested by Google Maps turn out to be illogical and uninteresting?
If you recognized yourself in at least one of these situations, then you need our application.

Features
Filtering by initial geolocation
Filtering by radius
Filtering by places
Getting Started
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

Lab: Write your first Flutter app
Cookbook: Useful Flutter samples
For help getting started with Flutter development, view the
online documentation, which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Installation
To get started with this Flutter project, follow these steps:

Clone the repository:

bash
Copy code
git clone https://github.com/your-username/travely.git
Navigate to the project directory:

bash
Copy code
cd travely
Install dependencies:

bash
Copy code
flutter pub get
Set up Firebase:

Go to the Firebase Console.
Create a new project.
Add an Android/iOS app to your project and follow the setup steps.
Download the google-services.json file for Android and place it in the android/app directory.
Download the GoogleService-Info.plist file for iOS and place it in the ios/Runner directory.
Add the Firebase SDK to your app by following the Firebase setup instructions.
Run the project:

bash
Copy code
flutter run
Project Structure
The project structure follows a standard Flutter project layout:

bash
Copy code
travely/
|- android/
|- ios/
|- lib/
   |- main.dart
   |- screens/
   |- widgets/
|- test/
|- pubspec.yaml
android/ and ios/: Platform-specific code for Android and iOS.
lib/: Contains the main Dart codebase.
main.dart: Entry point of the application.
screens/: Contains different screens/pages of the app.
widgets/: Contains reusable widgets.
test/: Contains test files.
pubspec.yaml: Contains metadata and dependencies for the project.
Usage
To use this project:

Ensure you have Flutter installed. You can download it from Flutter's official website.
Follow the installation steps mentioned above.
Customize the project according to your needs by modifying the code in the lib/ directory.
Screenshots
Here are some screenshots of the application:

Home Screen

Details Screen

Video Demo
Check out this video demo of the application:


Contributing
We welcome contributions! Please follow these steps to contribute:

Fork the repository.
Create a new branch: git checkout -b feature/your-feature-name
Make your changes.
Commit your changes: git commit -m 'Add some feature'
Push to the branch: git push origin feature/your-feature-name
Open a pull request.
License
This project is licensed under the MIT License - see the LICENSE file for details.