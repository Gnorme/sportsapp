import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page extends StatefulWidget {
  @override 
  _PageState createState() => new _PageState();
}
class _PageState extends State<Page>{
  List<String> _favTeams = [];
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _favTeams = prefs.getStringList('hockey_teams');
    });
  }
  @override
  void initState(){
    super.initState();
    _loadSettings();
  }
  @override
  Widget build(BuildContext context) {
    //declare constants

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        title: new Text("My Teams",style: const TextStyle(color:Colors.black)),
      ),
      body: new Container(child: new GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: _favTeams.map((String team) {
            return new GridTile(
                child: new IconButton(icon: new Image.asset("images/hockey/$team.png", fit: BoxFit.cover),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/teamhome/$team');
                  }
                ));
          }).toList()),
      ),
    );
  }
}
      //new Row(children: <Widget>[
        //ew IconButton(icon: new Image.asset("images/hockey/canadiens.png"),onPressed: (){Navigator.of(context).pushNamed('/teamhome/canadiens');}),
        //new IconButton(icon: new Image.asset("images/hockey/senators.png"),onPressed: (){Navigator.of(context).pushNamed('/teamhome/senators');}),
      //])),
