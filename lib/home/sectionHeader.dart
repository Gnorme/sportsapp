import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final AlignmentGeometry alignment;
  ScrollController _scrollController = new ScrollController();
  SectionHeader({this.title,this.onTap, this.alignment});
  @override
  Widget build(BuildContext context){
    return new AnimatedContainer(duration: const Duration(milliseconds:300),padding:new EdgeInsets.only(top:4.0,left:4.0),alignment: alignment,child:new FlatButton(onPressed:onTap,
    child:new Text(title, style:new TextStyle(fontSize:24.0))));
  }
}

