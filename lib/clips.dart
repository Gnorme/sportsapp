import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Page extends StatefulWidget {
  final String team;
  Page({this.team});
  @override
  _PageState createState() => new _PageState(team:team);
}

class _PageState extends State<Page> {
  String _clips = 'Unknown';
  final String team;
  _PageState({this.team});
  VideoPlayerController _controller;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController(
      'https://cf-b2.streamablevideo.com/video/mp4/b5dyr.mp4?token=1514915442-RL3y7t%2B2pSL9dcZUlyCSLRr7BJjLfD8fx2lYzK2NYoA%3D',
  )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize();
  }
  _getClips() async {
    String url = 'http://192.168.1.105:7005/clips?team=$team';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    var data = JSON.decode(response);
    print(data);

    setState((){
      _clips = data[0]['url'];
      _controller = new VideoPlayerController('$_clips');
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
            new AspectRatio(
              aspectRatio: 1280/720,
              child:new VideoPlayer(_controller),
            ),
            //new Chewie(new VideoPlayerController('https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4'),aspectRatio: 3 / 2,autoPlay: false, looping: false),
            spacer,
            new RaisedButton(
              onPressed: _getClips,
              child: new Text('Get Clip'),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed:
            _controller.value.isPlaying ? _controller.pause : _controller.play,
        child: new Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),      
    );
  }
}