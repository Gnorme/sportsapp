import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Page extends StatefulWidget {
  final String team;
  Page({this.team});
  @override
  _PageState createState() => new _PageState(team:team);
}

class _PageState extends State<Page> {
  String _photos = 'Unknown';
  final String team;
  _PageState({this.team});
  _getPhotos() async {
    String url = 'http://192.168.1.105:7005/photos?team=$team';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    var data = JSON.decode(response);
    print(data);

    setState((){
      _photos = data[0]['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget>[
            spacer,
            new Image.network('$_photos'),
            spacer,
            new RaisedButton(
              onPressed: _getPhotos,
              child: new Text('Get Photo'),
            ),
          ],
        ),
      ),
    );
  }
}