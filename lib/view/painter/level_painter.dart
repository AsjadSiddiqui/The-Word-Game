import 'package:flutter/material.dart';
import 'package:the_word_game/pages/game.dart';
import 'dart:ui' as ui;
import 'package:touchable/touchable.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Map1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.2)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 3)
      ..strokeWidth = 20.0;

    Paint paint_0 = new Paint()
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.colorBurn
      ..strokeWidth = 33.0;

    paint_0.shader = ui.Gradient.linear(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      [
        Color(0xffd2a500),
        Color(0xFFFFFFFF),
      ],
    );

    Path path_0 = Path();

    path_0.moveTo(0, size.height * 0.91);

    path_0.quadraticBezierTo(size.width * 0.43, size.height * 0.89,
        size.width * 0.61, size.height * 0.83);

    path_0.cubicTo(size.width * 0.76, size.height * 0.77, size.width * 0.86,
        size.height * 0.71, size.width * 0.75, size.height * 0.66);

    path_0.cubicTo(size.width * 0.55, size.height * 0.58, size.width * 0.30,
        size.height * 0.74, size.width * 0.25, size.height * 0.61);

    path_0.cubicTo(size.width * 0.21, size.height * 0.48, size.width * 0.81,
        size.height * 0.54, size.width * 0.81, size.height * 0.44);
    path_0.cubicTo(size.width * 0.80, size.height * 0.31, size.width * 0.29,
        size.height * 0.40, size.width * 0.28, size.height * 0.31);

    path_0.quadraticBezierTo(
        size.width * 0.29, size.height * 0.19, size.width, size.height * 0.16);

    canvas.drawPath(path_0, paint_1);
    canvas.drawPath(path_0, paint_0);

    print("size of canvas is " + size.toString());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CirclesPainter extends CustomPainter {
  final BuildContext context;
  final int unlockedNumbers;
  final List<Offset> values;
  final List<List<String>> words;
  final int begin;
  double radius = 10.0;

  CirclesPainter(this.context, this.values, this.words,
      {this.unlockedNumbers = 5, this.begin = 0});

  paintNumber(Canvas canvas, int number, Offset position) {
    var textSpan = TextSpan(
        text: number.toString(),
        style: TextStyle(
          fontFamily: "Reem Kuffi",
          color: Colors.amber.shade800,
          fontSize: 30,
        ));
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint_0 = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.darken
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    final Paint paint_2 = new Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white54;

    values.forEach((e) {
      int i = values.indexOf(e);
      final isUnlocked = unlockedNumbers > i;
      if (isUnlocked) {
        radius = 28.0;
        for (int i = 1; i < 3; i++) {
          canvas.drawCircle(Offset(e.dx * size.width, e.dy * size.height),
              radius - radius / i, paint_2);
        }
      } else
        radius = 12.0;

      canvas.drawCircle(
        Offset(e.dx * size.width, (e.dy + 0.01) * size.height),
        radius,
        paint_0,
      );

      canvas.drawCircle(
        Offset(e.dx * size.width, e.dy * size.height),
        radius,
        paint_2,
      );

      if (isUnlocked) {
        final myCanvas = TouchyCanvas(context, canvas);
        myCanvas.drawCircle(Offset(e.dx * size.width, e.dy * size.height),
            radius - 5, paint_2..color = Colors.white70, onTapDown: (details) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Level1(words[i], i + 1)));
        });
        for (int i = 1; i < 3; i++) {
          canvas.drawCircle(Offset(e.dx * size.width, e.dy * size.height),
              radius - i * radius / 3, paint_2);
        }
        paintNumber(
            canvas,
            i + 1 + begin,
            Offset(e.dx * size.width - radius / 3,
                e.dy * size.height - radius / 1.3));
      }
    });
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CirclesPainter oldDelegate) => false;
}

class Map2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.2)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 3)
      ..strokeWidth = 20.0;

    Paint paint_0 = new Paint()
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.colorBurn
      ..strokeWidth = 33.0;

    paint_0.shader = ui.Gradient.linear(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      [Color(0xFFFFFFFF), Color(0xffd2a500)],
    );

    Path path_0 = Path();

    path_0.moveTo(0, size.height * 0.16);

    path_0.quadraticBezierTo(size.width * 0.31, size.height * 0.12,
        size.width * 0.36, size.height * 0.17);
    path_0.cubicTo(size.width * 0.45, size.height * 0.24, size.width * -0.07,
        size.height * 0.40, size.width * 0.19, size.height * 0.47);
    path_0.cubicTo(size.width * 0.59, size.height * 0.55, size.width * -0.02,
        size.height * 0.78, size.width * 0.17, size.height * 0.78);
    path_0.cubicTo(size.width * 0.27, size.height * 0.78, size.width * 0.62,
        size.height * 0.80, size.width * 0.75, size.height * 0.77);
    path_0.cubicTo(size.width * 0.95, size.height * 0.71, size.width * 0.40,
        size.height * 0.65, size.width * 0.53, size.height * 0.58);
    path_0.cubicTo(size.width * 0.65, size.height * 0.52, size.width * 0.76,
        size.height * 0.45, size.width * 0.83, size.height * 0.41);
    path_0.cubicTo(size.width * 0.95, size.height * 0.35, size.width * 0.44,
        size.height * 0.30, size.width * 0.56, size.height * 0.27);
    path_0.quadraticBezierTo(
        size.width * 0.72, size.height * 0.15, size.width, size.height * 0.14);

    canvas.drawPath(path_0, paint_1);
    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
