import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sectionHeader.dart';
import 'dart:convert';

class TrendingClips extends StatefulWidget {
  final ScrollController controller;
  TrendingClips({this.controller});
  @override
  _TrendingClipsState createState() => new _TrendingClipsState();
}

class _TrendingClipsState extends State<TrendingClips> {
  double sectionStart = 490.0;
  double sectionHeight = 200.0;
  double cardHeight = 135.0;
  double cardWidth = 164.0;  
  AlignmentGeometry headerAlignment = Alignment.centerLeft;
  Axis scrollDirection = Axis.horizontal;
  bool isBig = false;  
  void _handleSize(){
   //RenderBox test = context.findRenderObject();
   // Offset offset = test.localToGlobal(new Offset(0.0,-80.0));
    setState((){
      if (isBig) {
        sectionHeight = 200.0;
        cardHeight = 135.0;
        cardWidth = 164.0;
        scrollDirection = Axis.horizontal;
        headerAlignment = Alignment.centerLeft;
      } else {
        sectionHeight = 475.0;
        cardHeight = 250.0;
        cardWidth = 300.0;
        scrollDirection = Axis.vertical;
        headerAlignment = Alignment.center;
        widget.controller.animateTo(sectionStart, duration: new Duration(milliseconds: 1200), curve: Curves.ease);
      }
      isBig = !isBig;
    });
  }  
  @override
  Widget build(BuildContext context){
    return new Container(
      height:sectionHeight,
      child: new Column(children: <Widget>[
      new SectionHeader(title: "Clips", onTap:_handleSize,alignment:headerAlignment),    
      new AnimatedContainer(
        duration: const Duration(milliseconds:300),
        height: sectionHeight - 55,
        child: new ListView(
          scrollDirection: scrollDirection,
          children: new List.generate(10, (int index) {
            return new Card(
              color: Colors.blue[index * 100],
              child: new Container(
                width: cardHeight,
                height: cardWidth,
                child: new Text("$index"),
              ),
            );
          }),
        ),
      )]),
    );
  }
}