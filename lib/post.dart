// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class PostData {
  int id;
  String title;
  String url;
  String submittedBy;
  String submittedAt;
  int score;
  String tags;
  String teams;

}
class Team {
  String name;
  String logo;
  String sport;

  Team(this.name, this.logo, this.sport);
}
// This demo is based on
// https://material.google.com/components/dialogs.html#dialogs-full-screen-dialogs

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class SubmitPost extends StatefulWidget {
  @override
  _SubmitPostState createState() => new _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var httpClient = createHttpClient();
  String _sport = '';
  List<String> _teams = ['Teams *'];
  PostData post = new PostData();
  void _setActiveSport(String sport) {
    _loadTeams(context, sport.toLowerCase());
  }
  void _setActiveTeam(String team) {
    post.teams = team.toLowerCase();
  } 
  _loadTeams(BuildContext context, String sport) async {
    List<String> teams = [];
    //List<Team> nhlTeams = [];
    var fileData = await DefaultAssetBundle.of(context).loadString('json/$sport/teams.json');
    var jData = JSON.decode(fileData);
    for (var team in jData){
        teams.add(team['name']);
    }
    post.tags = sport;
    setState((){
      _teams = teams;
    });   
  }  
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }
  postData() async {
    var url = "http://192.168.1.105:7005/post";
    String encodedString = JSON.encode({'id':0,'title': post.title, 'url': post.url,'submitted_by':'Gnorme','submitted_at':'today','score':0,'tags':post.tags,'teams':post.teams});
    var response = await httpClient.post(url, body: encodedString);
    print(url);
    print('Response status: ${response.statusCode}');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.pop(context,DismissDialogAction.save);
  }
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    form.save();
    showInSnackBar('Submitted');
    postData();
    
  }  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text('Text fields',style:const TextStyle(color:Colors.black)),
      ),
      body: new SafeArea(
        top:false,
        bottom: false,
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.subject),
                  hintText: 'Enter a title for your submission',
                  labelText: 'Title *',
                ),
                onSaved: (String value) {post.title = value;},
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.link),
                  hintText: 'Paste the URL for your submission',
                  labelText: 'Link *',
                ),
                onSaved: (String value) {post.url = value;},
              ),
              new SportOptions(onChanged:_setActiveSport),
              new TeamOptions(teams:_teams, onChanged: _setActiveTeam),
              new Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: new RaisedButton(
                  onPressed: _handleSubmitted,
                  child: const Text('SUBMIT'),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: new Text('* indicates required field', style: Theme.of(context).textTheme.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
class SportOptions extends StatefulWidget {
  final ValueChanged<String> onChanged;
  SportOptions({this.onChanged});
  @override
  _SportOptionsState createState() => new _SportOptionsState();
}

class _SportOptionsState extends State<SportOptions> {
int radioValue = 0;

  String sportDropdown;

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Sport:"),
            trailing: new Container(
              child: new DropdownButton<String>(
                value:sportDropdown,
                hint: new Text("Sport *"),
                onChanged:(String newValue) {
                  setState((){
                    sportDropdown = newValue;
                    widget.onChanged(newValue);
                  });
                },
                items: <String>['Hockey','Football','Soccer','Basketball','Baseball'].map((String value){
                  return new DropdownMenuItem<String>(
                    value:value,
                    child: new Text(value),
                  );
                }).toList(),
            ),
          ),                   
        ),
      ],
    );
  }
}
class TeamOptions extends StatefulWidget {
  final List<String> teams;
  final ValueChanged<String> onChanged;
  TeamOptions({Key key, this.teams, this.onChanged}) : super(key:key);
  @override
  _TeamOptionsState createState() => new _TeamOptionsState();
}

class _TeamOptionsState extends State<TeamOptions> {
  String teamDropdown;

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Team:"),
            trailing: new Container(
              child: new DropdownButton<String>(
                value:teamDropdown,
                hint: new Text("Team *"),
                onChanged:(String newValue) {
                  setState((){
                    teamDropdown = newValue;
                    widget.onChanged(newValue);
                  });
                },
                items: widget.teams.map((String value){
                  return new DropdownMenuItem<String>(
                    value:value,
                    child: new Text(value),
                  );
                }).toList(),
            ),
          ),                   
        ),
      ],
    );
  }
}