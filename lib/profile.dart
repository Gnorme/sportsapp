import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Team {
  String name;
  String logo;
  bool isCheck;
  String sport;

  Team(this.name, this.logo, this.isCheck, this.sport);
}

class Page extends StatelessWidget {
  final TextStyle headers = new TextStyle(color: Colors.grey, fontSize: 24.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(backgroundColor: Colors.white,title: new Text("Profile",style:const TextStyle(color:Colors.black))),
      body: new Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  //Profile({this.teams});
  //List<Team> teams;

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile>{
  final TextStyle headers = new TextStyle(color: Colors.grey, fontSize: 24.0);
  bool _settingsLoaded = false;
  //List<Team> _nhlTeams = [];
  Map _teams = {"hockey":[],"football":[]};
  List<String> _favTeams = [];
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favTeams = prefs.getStringList('hockey_teams');
    print(_favTeams);
    _settingsLoaded = true;
  }
  _loadTeams(BuildContext context, String sport) async {
    List<Team> teams = [];
    //List<Team> nhlTeams = [];
    var fileData = await DefaultAssetBundle.of(context).loadString('json/$sport/teams.json');
    var jData = JSON.decode(fileData);
    await _loadSettings();
    for (var team in jData){
      if (_favTeams.contains(team['name'])){
        teams.add(new Team(team['name'],'images/person.png',true,sport));
      } else {
        teams.add(new Team(team['name'],'images/person.png',false,sport));
      }
    }
    setState((){
      _teams[sport] = teams;
    });
  }  
  bool _isHidden = false;
  List data;
  String _activeSport = "hockey";
  //bool _isActive = false;
  void _setActiveTeam(String sport) {
    setState((){
      _activeSport = sport;
      _loadTeams(context,sport);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Container(child: new Column(children: [
        new Container(padding: const EdgeInsets.all(8.0),child:new Text("My Teams",style:headers)),
        new SportIcons(onChanged: _setActiveTeam),
        new Expanded(child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: _teams[_activeSport].map((Team team) {
            return new TeamListItem(team);
          }).toList(),
        )),
      ]),
    );    
  }
}

class TeamListItem extends StatefulWidget {
  final Team team;

  TeamListItem(Team team) : team = team, super(key: new ObjectKey(team));

  @override
  TeamState createState() {return new TeamState(team);}
}

class TeamState extends State<TeamListItem>{
  final Team team;

  TeamState(this.team);

  _saveSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _teams = prefs.getStringList('hockey_teams');
    var _favTeams = new List<String>.from(_teams);
    if (value){
      _favTeams.add(team.name);
    } else {
      _favTeams.remove(team.name);
    }
    prefs.setStringList('hockey_teams',_favTeams);
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap:null,
        leading: new CircleAvatar(
          backgroundColor: Colors.blue,
          child: new Image(image: new AssetImage(team.logo)),
        ),
        title: new Row(
          children: <Widget>[
            new Expanded(child: new Text(team.name)),
            new Checkbox(value: team.isCheck, onChanged: (bool value) {
              setState(() {
                team.isCheck = value;
                _saveSettings(value);
              });
            })
          ],
        )
    );
  }
}

class SportIcons extends StatefulWidget {
  SportIcons({this.onChanged});
  final ValueChanged<String> onChanged;
  @override _SportIconsState createState() => new _SportIconsState();
}

class _SportIconsState extends State<SportIcons>{
  Map sports = {'hockey':false,'football':false,'basketball':false,'baseball':false,'soccer':false};

  void _turnOffOthers(String sport) {
    setState((){
      for (var s in sports.keys) {
        sports[s] = false;
      }
      sports[sport] = true;
      widget.onChanged(sport);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row (children: <Widget>[
      new SportIcon(sport:"hockey",active:sports['hockey'], onChanged: _turnOffOthers),
      new SportIcon(sport:"football",active:sports['football'], onChanged: _turnOffOthers),
      new SportIcon(sport:"basketball",active:sports['basketball'], onChanged: _turnOffOthers),  
      new SportIcon(sport:"baseball",active:sports['baseball'], onChanged: _turnOffOthers),  
      new SportIcon(sport:"soccer",active:sports['soccer'], onChanged: _turnOffOthers),        
    ]);
  }
}

class SportIcon extends StatefulWidget {
  SportIcon({this.sport, this.onChanged, this.active});
  final ValueChanged<String> onChanged;
  final String sport;
  final bool active;

  @override
  _SportIconState createState() => new _SportIconState();
}

class _SportIconState extends State<SportIcon>{

  void _handleActive() {
      widget.onChanged(widget.sport);
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new IconButton(iconSize:28.0, padding: const EdgeInsets.all(1.0),
        icon:(widget.active ? new Image.asset('images/active/'+widget.sport+'.png') :new Image.asset('images/inactive/'+widget.sport+'.png')), 
        //icon:(widget.active ? new Icon(FontAwesomeIcons.undo) : new Icon(FontAwesomeIcons.undo)), 
        onPressed: _handleActive,    
      ),
    );
  }
}