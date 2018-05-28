import 'package:flutter/material.dart';


class Page extends StatefulWidget {
  final String team;
  Page({this.team});
  @override
  _PageState createState() => new _PageState(team:team);
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin{
  TabController controller;
  final String team;
  _PageState({this.team});

  @override
  void initState(){
    super.initState();

    controller = new TabController(initialIndex: 1,length:4,vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //declare constants

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text(team,style:const TextStyle(color:Colors.black)),
      ),
      body: new Container(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new MyCard(title: "Chat",screen:'/post/$team'),
              new MyCard(title: "Roster",screen:'/roster/$team'),
              new MyCard(title: "Standings",screen:'/standings/$team'),
              new MyCard(title: "Insiders",screen:'/insiders/$team'),
              new MyCard(title: "Articles",screen:'/articles/$team'),
              new MyCard(title: "Photos",screen:'/photos/$team'),
              new MyCard(title: "Clips",screen:'/clips/$team'),
              new MyCard(title: "Friends",screen:'/friends/$team'),                                                      
            ],
          ),
        ),       
      ),
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
          ],controller:controller,
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String title;
  final String screen;
  final TextStyle myTextStyle = new TextStyle(color: Colors.grey, fontSize: 24.0);
  MyCard({this.title,this.screen});

  @override
  Widget build(BuildContext context){
    return new Container( 
      margin: const EdgeInsets.only(top: 20.0),             
      child: new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
        new Flexible(child: new FlatButton(child:new Text(this.title, style: myTextStyle),onPressed: (){
          Navigator.of(context).pushNamed(this.screen);
        })),
      ]),
    );
  }
}