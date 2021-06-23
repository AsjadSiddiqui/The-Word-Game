import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:the_word_game/pages/home_page.dart';
import 'package:the_word_game/view/painter/level_painter.dart';
import 'package:touchable/touchable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelPage extends StatelessWidget {
  final _fireStore = FirebaseFirestore.instance;
  int unlockedNum;
  Future<List<Widget>> _initialise() async {
    await Hive.openBox("myBox");
    var box = Hive.box("myBox");
    // this if it's the first time
    if (box.get("level") == null) {
      box.put("level", 1);
    }
    unlockedNum = box.get("level");
    _fireStore
        .collection("level")
        .doc("Cuf6fklY7zU8msncS1Bg")
        .update({"levelNumber": unlockedNum});
    print(unlockedNum);
    return [MapPage1(unlockedNum), MapPage2(unlockedNum - 6)];
  }

  final SwiperController _controller = new SwiperController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade300,
        body: FutureBuilder(
            future: _initialise(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Swiper(
                  physics: CustomPageViewScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: 2,
                  indicatorLayout: PageIndicatorLayout.WARM,
                  loop: false,
                  controller: _controller,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(size: 16, space: 6)),
                  control: SwiperControl(
                      size: 50,
                      iconPrevious: Icons.arrow_left_rounded,
                      iconNext: Icons.arrow_right_rounded,
                      disableColor: Colors.brown.shade100),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return snapshot.data[index];
                  },
                );
              } else
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.brown.shade200)));
            }),
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}

class MapPage extends StatelessWidget {
  final String assetPath;
  final Widget child;
  MapPage({Key key, @required this.assetPath, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white10,
              image: DecorationImage(
                  image: AssetImage(assetPath), fit: BoxFit.cover)),
          child: child,
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: NeumorphicButton(
              child: Icon(
                Icons.chevron_left_rounded,
                size: 27,
              ),
              margin: EdgeInsets.all(12),
              style: NeumorphicStyle(
                depth: 2,
                color: Colors.transparent,
                shape: NeumorphicShape.convex,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        /*        SafeArea(
          child: AlignedIconButton(
            icon: FontAwesomeIcons.store,
            onPressed: () {
              print("pressed");
            },
          ),
        ) */
      ],
    );
  }
}

class MapPage1 extends StatelessWidget {
  final int unlockedNum;
  final circlePosition = [
    Offset(0.61, 0.83),
    Offset(0.75, 0.66),
    Offset(0.25, 0.61),
    Offset(0.81, 0.44),
    Offset(0.28, 0.31),
    Offset(0.61, .19),
  ];
  final words = [
    ["zero", "two", "one"],
    ["three", "five", "four"],
    ["six", "eight", "seven"],
    ["nine", "first", "ten"],
    ["blue", "red", "green"],
    ["white", "black", "pink"],
  ];
  MapPage1(this.unlockedNum);

  @override
  Widget build(BuildContext context) {
    return MapPage(
      assetPath: "assets/images/map1.png",
      child: CustomPaint(
        painter: Map1Painter(),
        child: CanvasTouchDetector(
            builder: (BuildContext context) => CustomPaint(
                  painter: CirclesPainter(context, circlePosition, words,
                      unlockedNumbers: unlockedNum),
                )),
      ),
    );
  }
}

class MapPage2 extends StatelessWidget {
  final int unlockedNum;
  final circlePosition = [
    Offset(0.36, 0.17),
    Offset(0.19, 0.47),
    Offset(0.17, 0.78),
    Offset(0.75, 0.77),
    Offset(0.53, 0.58),
    Offset(0.83, .41),
    Offset(0.56, .27),
  ];

  final words = [
    ["fruit", "kiwi", "melon"],
    ["pear", "apple", "grape"],
    ["berry", "coco", "lime"],
    ["peach", "mango", "fig"],
    ["cake", "pizza", "pasta", "rice"],
    ["fish", "meat", "egg"],
    ["chips", "pie", "toast", "bread"]
  ];

  MapPage2(this.unlockedNum);
  @override
  Widget build(BuildContext context) {
    return MapPage(
      assetPath: "assets/images/map2.png",
      child: CustomPaint(
        painter: Map2Painter(),
        child: CanvasTouchDetector(
            builder: (context) => CustomPaint(
                  painter: CirclesPainter(context, circlePosition, words,
                      unlockedNumbers: unlockedNum, begin: 6),
                )),
      ),
    );
  }
}
