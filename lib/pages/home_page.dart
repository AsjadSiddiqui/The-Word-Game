import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:splash_tap/splash_tap.dart';
import 'package:the_word_game/pages/auth_page.dart';
import 'package:the_word_game/pages/instructions_page.dart';
import 'package:the_word_game/pages/level_page.dart';
import 'package:the_word_game/pages/sign_out_page.dart';
import 'package:the_word_game/utils/regular/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;

  final player = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    super.initState();
    AssetsAudioPlayer.playAndForget(Audio("assets/sounds/our_mountain.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _quitTheApp(context);
        return true;
      },
      child: Scaffold(
          body: Splash(
              minRadius: 10.0,
              maxRadius: 50,
              splashColor: Colors.white,
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/home_background.png"),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _playButton(context),
                      _helpButton(context),
                      _loginButton(context)
                    ],
                  ),
                ),
              ))),
    );
  }

  _playButton(context) => Button(
        mText: "PLAY",
        mfontSize: 33,
        monPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LevelPage()),
          );
        },
      );

  _helpButton(context) => Button(
        mText: "INSTRUCTIONS",
        mfontSize: 16,
        monPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InstructionsScaffold()));
        },
      );

  _loginButton(context) => Button(
        mText: "Login / Signin",
        mfontSize: 20,
        monPressed: () {
          if (_auth.currentUser == null)
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          else
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignOutPage()));
        },
      );

  _quitTheApp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 8,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(20))),
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FancyScoreText(
                                  "Do you Really want to quit ?"),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.redAccent)),
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                  child: FancyScoreText(
                                    "yes",
                                    color: Colors.red,
                                  )),
                            ),
                            Expanded(
                              child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.blueAccent)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: FancyScoreText(
                                    "No",
                                    color: Colors.blue,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }
}
