import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:the_word_game/pages/home_page.dart';

class WordSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          image: DecorationImage(
              image: AssetImage("assets/images/splash_background.png"),
              fit: BoxFit.cover)),
      child: SplashScreen.navigate(
        name: 'assets/intro.riv',
        next: (context) => HomePage(),
        until: () => Future.delayed(Duration(seconds: 2)),
        startAnimation: 'Animation 1',
        loopAnimation: 'Animation 1',
        endAnimation: 'Animation 1',
      ),
    );
  }
}

class Button extends StatefulWidget {
  final String mText;
  final double mwidth;
  final double mfontSize;
  final Function monPressed;
  const Button({
    Key key,
    this.mText = "",
    this.mwidth = 250,
    this.mfontSize = 33,
    @required this.monPressed,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

bool press = false;

class ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        AssetsAudioPlayer.playAndForget(
          Audio("assets/sounds/tapDown.mp3"),
        );
        press = true;
        setState(() {});
      },
      onTapUp: (details) {
        AssetsAudioPlayer.playAndForget(
          Audio("assets/sounds/tapUp.mp3"),
        );

        setState(() {});
        press = false;
        widget.monPressed();
      },
      onTapCancel: () {
        AssetsAudioPlayer.playAndForget(
          Audio("assets/sounds/tapDown.mp3"),
        );
        setState(() {});
        press = false;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
        width: 254,
        height: 54,
        alignment: Alignment.center,
        transform: Transform.scale(scale: press ? 0.97 : 1.0).transform,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, press ? 0.0 : 0.4),
                offset: Offset(0, press ? 0 : 4),
                blurRadius: 1)
          ],
          gradient: LinearGradient(
              colors: !press
                  ? [
                      Color.fromARGB(255, 253, 252, 251),
                      Color.fromARGB(255, 226, 209, 195)
                    ]
                  : [
                      Color.fromARGB(220, 253, 252, 251),
                      Color.fromARGB(200, 226, 209, 195)
                    ]),
        ),
        child: GoldenText(widget.mText, mfontSize: widget.mfontSize),
      ),
    );
  }
}

class GoldenText extends StatelessWidget {
  final String mText;
  final double mfontSize;
  final FontWeight mfontWeight;
  const GoldenText(
    this.mText, {
    Key key,
    this.mfontSize = 33,
    this.mfontWeight = FontWeight.w800,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      mText,
      textStyle: NeumorphicTextStyle(
          fontSize: mfontSize,
          fontWeight: mfontWeight,
          fontFamily: "Reem kuffi"),
      style: NeumorphicStyle(
        surfaceIntensity: 0.25,
        color: Colors.amber.shade700,
        depth: 1,
        border: NeumorphicBorder(
            color: Color.fromRGBO(250, 255, 2, 0.5), width: 1.2),
      ),
    );
  }
}

/// SECOND PAGE WIDGETS
class LevelButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool unlocked;
  const LevelButton(
      {Key key,
      @required this.onPressed,
      @required this.text,
      @required this.unlocked})
      : super(key: key);
  @override
  LevelButtonState createState() => LevelButtonState();
}

class LevelButtonState extends State<LevelButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.unlocked ? 1.0 : 0.0,
      child: NeumorphicButton(
        curve: Curves.easeInOut,
        style: NeumorphicStyle(
            color: Color.fromRGBO(208, 168, 100, 1),
            shape: NeumorphicShape.convex,
            depth: 8,
            boxShape: NeumorphicBoxShape.circle()),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: GoldenText(
            widget.text,
            mfontSize: 22,
          ),
        ),
        onPressed: () {
          setState(() {});
          widget.onPressed();
        },
      ),
    );
  }
}
// THIRD PAGE WIDGETS

class Word extends StatefulWidget {
  final String mText;
  final double mfontSize;
  final Color color;
  final int wordScore;
  const Word({
    Key key,
    this.mText = "",
    this.mfontSize = 33,
    Text child,
    this.color,
    this.wordScore,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WordState();
  }
}

class WordState extends State<Word> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
        color: widget.color,
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: GoldenText(widget.mText, mfontSize: widget.mfontSize)),
          Container(
            margin: EdgeInsets.only(right: 2.0),
            alignment: Alignment.bottomRight,
            child: FancyScoreText(
              "${widget.wordScore}",
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}

class WordBackground extends StatelessWidget {
  final Widget child;

  const WordBackground({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: EdgeInsets.all(5),
      style: NeumorphicStyle(
          color: Colors.white,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
      child: child,
    );
  }
}

class FancyScoreText extends StatelessWidget {
  final String text;
  final double fontSize;

  final Color color;

  const FancyScoreText(this.text,
      {this.fontSize = 16, this.color = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: "Reem kuffi", fontSize: fontSize, color: color));
  }
}
/* 
class AlignedIconButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;
  const AlignedIconButton({Key key, this.onPressed, this.icon})
      : super(key: key);

  @override
  _AlignedIconButtonState createState() => _AlignedIconButtonState();
}

class _AlignedIconButtonState extends State<AlignedIconButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: FlatButton.icon(
          height: 70,
          highlightColor: Colors.brown.withOpacity(0.2),
          shape: CircleBorder(),
          disabledColor: Colors.grey,
          splashColor: Colors.white30,
          icon: Icon(FontAwesomeIcons.store, color: Colors.brown.shade500),
          onPressed: () {
            widget.onPressed();
            setState(() {});
          },
          label: GoldenText(
            "shop",
            mfontSize: 14,
            mfontWeight: FontWeight.w200,
          ),
        ));
  }
}
 */