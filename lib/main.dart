import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_word_game/utils/regular/widgets.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //* Needed For Firebase core
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  runApp(WordApp());
}

class WordApp extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Initialize Lit Firebase Auth. Needs to be called before
          // `MaterialApp`, to ensure all of the child widget, even when
          // navigating to a new route, has access to the Lit auth methods

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'The Word Game',
            themeMode: ThemeMode.light,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(
              primaryColor: Colors.brown.shade600,
              fontFamily: "Reem Kuffi",
              visualDensity: VisualDensity.adaptivePlatformDensity,
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.white,
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            home: WordSplashScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center();
      },
    );
  }
}
