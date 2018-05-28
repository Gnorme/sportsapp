import 'package:flutter/material.dart';
import './chat.dart' as chat;
import './home.dart' as home;
import './profile.dart' as profile;
import './roster.dart' as roster;
import './teamhome.dart' as teamhome;
import './teams.dart' as teams;
import './standings.dart' as standings;
import './post.dart' as post;
import './insiders.dart' as insiders;
import './photos.dart' as photos;
import './clips.dart' as clips;
import './friends.dart' as friends;
import './articles.dart' as articles;


void main() {
  runApp(new MyApp());
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    // Fades between routes. (If you don't want any animation, 
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Navigation example',
      home: new MyHome(),
      onGenerateRoute: (RouteSettings settings) {
        var route = settings.name.split("/");
        String dest = route[1];
        String team = route[2];
        switch (dest) {
          case 'teamhome': return new MyCustomRoute(
            builder: (_) => new teamhome.Page(team:team),
            settings: settings,
          );

          case 'chat': return new MyCustomRoute(
            builder: (_) => new chat.Page(team:team),
            settings: settings,
          );
          case 'roster': return new MyCustomRoute(
            builder: (_) => new roster.Page(team:team),
            settings: settings,
          );          
          case 'standings': return new MyCustomRoute(
            builder: (_) => new standings.Page(team:team),
            settings: settings,
          );          
          case 'insiders': return new MyCustomRoute(
            builder: (_) => new insiders.Page(team:team),
            settings: settings,
          );
          case 'articles': return new MyCustomRoute(
            builder: (_) => new articles.Page(team:team),
            settings: settings,
          );
          case 'photos': return new MyCustomRoute(
            builder: (_) => new photos.Page(team:team),
            settings: settings,
          );
          case 'clips': return new MyCustomRoute(
            builder: (_) => new clips.Page(team:team),
            settings: settings,
          ); 
          case 'friends': return new MyCustomRoute(
            builder: (_) => new friends.Page(team:team),
            settings: settings,
          );                                                                     
        }
        assert(false);
      }
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState(){
    super.initState();

    controller = new TabController(length:4,vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
 // final ScrollPhysics physics = new NeverScrollableScrollPhysics();
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(children: <Widget>[
        new home.Page(),
        new teams.Page(),
        new chat.Page(),
        //new post.Page(),
        new profile.Page()
      ],controller:controller, physics: new NeverScrollableScrollPhysics()),
      bottomNavigationBar: new Material(
        elevation: 20.0,
        color: Colors.white,
        child: new TabBar(labelColor: Colors.black, indicatorColor: Colors.black,
          tabs: <Tab>[
            new Tab(text:"Home"),
            new Tab(text:"My Teams"),
            new Tab(text:"Chat"),
            //new Tab(text:"Post"),
            new Tab(text:"Profile"),
        ],controller:controller),
      ),
    );
  }
}

