import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './post.dart';
import 'home/trendingArticles.dart';
import 'home/trendingClips.dart';
import 'home/trendingPhotos.dart';
import 'home/sectionHeader.dart';
import 'dart:convert';

class Page extends StatelessWidget {
  ScrollController _scrollController = new ScrollController();

  void showDemoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          body: new CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              new SliverAppBar(expandedHeight:64.0,pinned:true, backgroundColor: Colors.white,
              elevation:2.0,
              forceElevated: true,
              title: new Container(padding: new EdgeInsets.only(top:4.0,bottom:2.0),child: new TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                labelStyle: new TextStyle(fontSize:12.0,fontWeight:FontWeight.bold),
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return new Tab(
                    text: choice.title,
                    icon: new Image.asset(choice.icon, height:22.0),
                  );
                }).toList(),
              ))),
              new SliverList(
                delegate:new SliverChildListDelegate([
                new RaisedButton(
                  child: const Text('Submit Post'),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
                      builder: (BuildContext context) => new SubmitPost(),
                      fullscreenDialog: true,
                    ));
                  }
                ),              
                new TrendingArticles(),
                new TrendingPhotos(controller:_scrollController),
                new TrendingClips(controller:_scrollController),
                //new SectionHeader(title: "Photos"),
                //new TrendingSection(),  
                //new SectionHeader(title: "Clips"),
                //new TrendingSection(),
                new SectionHeader(title: "Tweets"),
                new TrendingSection(),                                                        
              ])),
          ]),
        ),
      ),
    );
  }
}

class TrendingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new Container(
      height: 120.0,
      width: 80.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: new List.generate(10, (int index) {
          return new Card(
            color: Colors.blue[index * 100],
            child: new Container(
              width: 120.0,
              height: 120.0,
              child: new Text("$index"),
            ),
          );
        }),
    ));
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final String icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'HOCKEY', icon: 'images/active/hockey.png'),
  const Choice(title: 'FOOTBALL', icon: 'images/active/football.png'),
  const Choice(title: 'BASKETBALL', icon: 'images/active/basketball.png'),
  const Choice(title: 'SOCCER', icon: 'images/active/soccer.png'),
  const Choice(title: 'BASEBALL', icon: 'images/active/baseball.png')
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

