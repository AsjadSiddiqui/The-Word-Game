import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hive/hive.dart';
import 'package:the_word_game/pages/sign_out_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  ///create a new Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Word',
      logo: 'assets/icon/icon.png',
      loginAfterSignUp: false,
/*       loginProviders: [
        LoginProvider(
            icon: FontAwesomeIcons.google,
            callback: () => Future(() {
                  _auth.signInWithCredential(AuthCredential(providerId: 'google.com', signInMethod: ''));
                  return;
                }))
      ], */
      onLogin: (data) => Future(() {
        _auth.signInWithEmailAndPassword(
            email: data.name, password: data.password);
        Hive.openBox("myBox");
        var box = Hive.box("myBox");

        _fireStore
            .collection("level")
            .doc("Cuf6fklY7zU8msncS1Bg")
            .get()
            .then((value) {
          var d = value.data();
          box.put("level", d["levelNumber"]);
        });

        return;
      }),
      onSignup: (data) => Future(() {
        _auth.createUserWithEmailAndPassword(
            email: data.name, password: data.password);

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
            .update({"levelNumber": unlockedNum});

        return;
      }),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SignOutPage(),
        ));
      },
      onRecoverPassword: (email) => Future(() {
        _auth.sendPasswordResetEmail(email: email);

        return;
      }),
      messages: LoginMessages(
        usernameHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot Password',
        recoverPasswordButton: 'Recover Pass',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordDescription:
            'The reset password will be sent to your email',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
    );
  }
}
