import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Page extends StatefulWidget {
  String team;
  Page({this.team});
  @override
  _PageState createState() => new _PageState(team:team);
}

class _PageState extends State<Page> {
  String _articles = 'Unknown';
  String team;
  _PageState({this.team});
  
  _getArticles() async {
    String url = 'http://192.168.1.105:7005/articles?team=$team';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    var data = JSON.decode(response);
    print(data);

    setState((){
      _articles = data[0]['title'];
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
            new Text('Article title is:'),
            new Text('$_articles.'),
            spacer,
            new RaisedButton(
              onPressed: _getArticles,
              child: new Text('Get Article'),
            ),
          ],
        ),
      ),
    );
  }
}
