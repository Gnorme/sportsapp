import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

class Player{
  String photo;
  String name;
  String number;
  String position;
  List<Stats> stats;

  Player({this.photo,this.name,this.number,this.position,this.stats});
}

class Stats {
  String year;
  String games;
  String goals;
  String assists;
  String shots;
  String hits;
  String timeOnIce;
  String penaltyMinutes;
  String plusMinus;

  Stats({this.year, this.games,this.assists,this.shots,this.hits,this.timeOnIce,this.penaltyMinutes,this.plusMinus});

  bool get isValid => year != null && games != null && goals != null && assists != null && shots != null && hits != null && timeOnIce != null && penaltyMinutes != null && plusMinus != null;

  Stats.fromJson(Map value){
    year = value['season'];
    games = value['stat']['games'].toString();
    goals = value['stat']['goals'].toString();
    assists = value['stat']['assists'].toString();
    shots = value['stat']['shots'].toString();
    hits = value['stat']['hits'].toString();
    timeOnIce = value['stat']['timeOnIce'];
    penaltyMinutes = value['stat']['penaltyMinutes'];
    plusMinus = value['stat']['plusMinus'].toString();
  }
}

class Page extends StatefulWidget {
  final String team;
  Page({this.team});
  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<Page> {
  List<Player> _players = [];
  @override
  void initState(){
    this.getData();
  }

  _returnStats(dynamic data){
    Player player = new Player();
    player.name = data['people'][0]['fullName'];
    player.number = data['people'][0]['primaryNumber'];
    player.photo = 'images/hockey/Canadiens.png';
    player.position = data['people'][0]['primaryPosition']['name'];
    player.stats = [];
    for (Map stats in data['people'][0]['stats'][0]['splits']){
      if (stats['league']['name'] != "National Hockey League"){
        continue;
      }
      player.stats.add(new Stats.fromJson(stats));
    }
    return player;    
  }  
  Future<String> getData() async {
    List<Player> players = [];
    var httpClient = createHttpClient();
    var roster = await DefaultAssetBundle.of(context).loadString('json/hockey/rosters/${widget.team}.json');
    var teamData = JSON.decode(roster);
    for (var p in teamData){      
      String url = 'https://statsapi.web.nhl.com/api/v1/people/${p['person']['id']}?expand=person.stats&stats=yearByYear';
      var response = await httpClient.read(url);
      var data = JSON.decode(response);
      Player player = _returnStats(data);
      players.add(player);   
    }
    setState((){
      _players = players;
    });    
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(title: new Text("Roster")),
      body: new ListView.builder(
        itemCount: _players == null ? 0 : _players.length,
        itemBuilder: (BuildContext context, int index) {
          return new RosterCard(player:_players[index]);
        },
      ),
    );
  }
}

class CustomTableRow extends StatelessWidget{
  String text;
  CustomTableRow({Key key,this.text});
  @override
  Widget build(BuildContext context){
    return new Container(child:new Text(text),padding:const EdgeInsets.only(bottom:8.0));
  }
}

class RosterCard extends StatelessWidget {
  Player player;
  List<TableRow> statRows = [];
  RosterCard({Key key, this.player});
  void _buildRows(){
    statRows = [
    new TableRow(children:<Widget>[
      new CustomTableRow(text:"GP"),
      new CustomTableRow(text:"G"),
      new CustomTableRow(text:"A"),
      new CustomTableRow(text:"S"),
      new CustomTableRow(text:"Hits"),
      new CustomTableRow(text:"TOI"),
      new CustomTableRow(text:"PIM"),
      new CustomTableRow(text:"+/-"),
    ])];    
    for(var year in player.stats){
      if (year.isValid){
        TableRow row;
        row = new TableRow(children:<Widget>[
          new CustomTableRow(text:year.games.toString()),
          new CustomTableRow(text:year.goals.toString()),
          new CustomTableRow(text:year.shots.toString()),
          new CustomTableRow(text:year.assists.toString()),
          new CustomTableRow(text:year.hits.toString()),
          new CustomTableRow(text:year.timeOnIce),
          new CustomTableRow(text:year.penaltyMinutes),
          new CustomTableRow(text:year.plusMinus.toString()),
        ]);
        statRows.add(row);
      }     
    }
  }
  @override
  Widget build(BuildContext context) {
    _buildRows();
    return new Card(
      child: new Column(children: <Widget>[
        new Row(children:<Widget>[
          new Image.asset("images/hockey/Canadiens.png"),
          new Container(
            padding: new EdgeInsets.only(left:20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Name: ${player.name}"),
                new Text("Number: ${player.number}"),
                new Text("Position: ${player.position}"),
            ]),
          ),
        ]),
        new Table(children:statRows,defaultColumnWidth: const FixedColumnWidth(40.0),columnWidths:const <int, TableColumnWidth>{
          5: const FixedColumnWidth(60.0)
        }),
      ]),
    );
  }
}