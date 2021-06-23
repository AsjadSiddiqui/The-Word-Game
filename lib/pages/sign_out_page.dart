import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:the_word_game/pages/auth_page.dart';
import 'package:the_word_game/pages/home_page.dart';
import 'package:the_word_game/utils/regular/widgets.dart';

class SignOutPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiquidWelcome(),
          Button(
            mText: "Sign Out",
            monPressed: () {
              if (_auth.currentUser != null) {
                //save progress then sign out
                Hive.openBox("myBox");
                var box = Hive.box("myBox");
                // this if it's the first time
                if (box.get("level") == null) {
                  box.put("level", 1);
                }
                var unlockedNum = box.get("level");
                _fireStore
                    .collection("level")
                    .doc("Cuf6fklY7zU8msncS1Bg")
                    .update({"levelNumber": unlockedNum}).then(
                        (value) => _auth.signOut());
              }
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          Button(
            mText: "Back",
            monPressed: () {
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          )
        ],
      ),
    );
  }
}

class LiquidWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextLiquidFill(
      text: 'WELCOME',
      waveColor: Colors.blueAccent,
      boxBackgroundColor: Colors.grey.shade200,
      textStyle: TextStyle(
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
      ),
      loadUntil: 0.7,
      boxHeight: 100,
    );
  }
}
