import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WordPanel extends StatelessWidget {
  final List<String> essantialWords;
  final List<String> additionalWords;

  bool _closed = false;

  WordPanel(
    this.essantialWords,
    this.additionalWords,
  );

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 70,
        maxHeight: 400,
        collapsed: Container(
          decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Center(
            child: Text(
              "Words Found ",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        panel: IgnorePointer(
          ignoring: true,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Essential Words",
                      style: kTextStylePanelHeader,
                    ),
                    Divider()
                  ]..addAll(essantialWords
                      .map((e) => Text(
                            e,
                            style: kTextStylePanelBody,
                          ))
                      .toList()),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Additional Words",
                      style: kTextStylePanelHeader,
                    ),
                    Divider()
                  ]..addAll(additionalWords
                      .map((e) => Text(
                            e,
                            style: kTextStylePanelBody,
                          ))
                      .toList()),
                ),
              ),
            ],
          ),
        ));
  }
}

const kTextStylePanelHeader = TextStyle(
    color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w500);
const kTextStylePanelBody = TextStyle(fontFamily: "Roboto", fontSize: 15);
