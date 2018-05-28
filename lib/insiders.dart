import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final String team;
  Page({this.team});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(title: new Text("Insiders")),
      body: new Center(child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,        
            children: <Widget>[
              new RaisedButton(onPressed:(){
                Navigator.of(context).pop(true);
              } ,child: new Text("Home"),)
            ],
        ),
      ),
    );
  }
}