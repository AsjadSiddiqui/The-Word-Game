import 'package:flutter/material.dart';
import 'package:the_word_game/utils/regular/widgets.dart';

class AnimatedWord extends StatefulWidget {
  final double fontSize;
  final int letterScore;
  const AnimatedWord({
    Key key,
    @required this.index,
    @required this.selected,
    @required this.mText,
    this.fontSize = 33,
    this.letterScore,
  }) : super(key: key);

  final String mText;
  final int index;
  final bool selected;

  @override
  _AnimatedWordState createState() => _AnimatedWordState();
}

class _AnimatedWordState extends State<AnimatedWord>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
 

    _controller = AnimationController(
      value: widget.selected ? 1.0 : 0.0,
      duration: kThemeAnimationDuration,
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void didUpdateWidget(AnimatedWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Word(
              color: Color.lerp(Colors.grey.shade200, Colors.green.shade600,
                  _controller.value),
              mText: widget.mText,
              mfontSize: widget.fontSize,
              wordScore: widget.letterScore,
            ),
          );
        });
  }
}
