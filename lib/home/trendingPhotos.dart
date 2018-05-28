import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sectionHeader.dart';
import 'dart:convert';

typedef void BannerTapCallback(Photo photo);

class Photo {
  Photo({
    this.title,
    this.url,
    this.submittedBy,
    this.submittedAt,
    this.score,
    this.tags,
    this.sport,
    this.isFavorite,
  });

  String title;
  String url;
  String submittedBy;
  String submittedAt;
  int score;
  String tags;
  String sport;
  bool isFavorite;

  //bool get isValid => title != null && url != null && submittedBy != null && submittedAt != null && score != null && tags != null && sport != null;
  bool get isValid => title != null && url != null && submittedBy != null && submittedAt != null && score != null && tags != null && sport != null;

  Photo.fromJson(Map value) {
    title = value['title'];
    url = value['url'];
    submittedAt = value['submitted_at'];
    submittedBy = value['submitted_by'];
    score = value['score'];
    tags = value['tags'];
    sport = value['sport'];
    isFavorite = false;
  }
}

class TrendingPhotos extends StatefulWidget{
  final ScrollController controller;
  const TrendingPhotos({ Key key,this.controller }) : super(key: key);

  static const String routeName = '/material/grid-list';

  @override
  _TrendingPhotosState createState() => new _TrendingPhotosState();
}

class _TrendingPhotosState extends State<TrendingPhotos>{
  List<Photo> photos = [];
  double sectionStart = 295.0;
  double sectionHeight = 200.0;
  double cardHeight = 135.0;
  double cardWidth = 164.0;
  AlignmentGeometry headerAlignment = Alignment.centerLeft;
  Axis scrollDirection = Axis.horizontal;
  bool isBig = false;
  _getArticles() async {
    String url = 'http://192.168.1.105:7005/photos?team=canadiens';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    var data = JSON.decode(response);
    print(data);
    setState((){
      data.map((Map photo){
        photos.add(new Photo.fromJson(photo));
      }).toList();
    });
  } 
  @override
  initState(){
    super.initState();
    _getArticles();   
  }
  void _handleSize(){
   //RenderBox test = context.findRenderObject();
   // Offset offset = test.localToGlobal(new Offset(0.0,-80.0));
    setState((){
      if (isBig) {
        sectionHeight = 200.0;
        cardHeight = 135.0;
        cardWidth = 164.0;
        scrollDirection = Axis.horizontal;
        headerAlignment = Alignment.centerLeft;
      } else {
        sectionHeight = 475.0;
        cardHeight = 250.0;
        cardWidth = 300.0;
        scrollDirection = Axis.vertical;
        headerAlignment = Alignment.center;
        widget.controller.animateTo(sectionStart, duration: new Duration(milliseconds: 1200), curve: Curves.ease);
      }
      isBig = !isBig;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      duration: const Duration(milliseconds:500),
      curve: const Cubic(0.25, 0.1, 0.25, 1.0),
      height:sectionHeight,
      child: new Column(children: <Widget>[
      new SectionHeader(title: "Photos", onTap:_handleSize,alignment:headerAlignment),
      new Container(
        //duration: const Duration(milliseconds:500),
        height:sectionHeight - 55,
        child: new ListView(
          scrollDirection: scrollDirection,
          children: photos.map((Photo photo) {
            return new PhotoCard(
              width: cardWidth,
              height: cardHeight,
              photo: photo,
              onBannerTap: (Photo photo) {
                setState(() {
                  photo.isFavorite = !photo.isFavorite;
                });
              }
            );
          }).toList(),
        ),
      ),
    ]));   
  }
}

class PhotoCard extends StatelessWidget {
  final flutterWebviewPlugin = new FlutterWebviewPlugin(); 
  double height;
  double width;
  PhotoCard({
    Key key,
    @required this.photo,
    @required this.onBannerTap,
    this.width,
    this.height,
  }); //: assert(article != null && article.isValid),
       //assert(onBannerTap != null),
       //super(key: key);

  final Photo photo;
  final BannerTapCallback onBannerTap; // User taps on the photo's header or footer.

  @override
  Widget build(BuildContext context) {
    final Widget image = new Container(
      height:height,
      width: width,
      child:new GestureDetector(
      onTap: () { flutterWebviewPlugin.launch(photo.url); },
      child: new Hero(
        key: new Key(photo.title),
        tag: photo.tags,
        child: new Image.network(
          photo.url,
          fit: BoxFit.cover,
        )
      )
    ));

    final IconData icon = photo.isFavorite ? Icons.star : Icons.star_border;
    return new Container(
      height:height,
      width:width,
      padding: new EdgeInsets.only(left:4.0, right:4.0,bottom:8.0),
      child: new GridTile(
      footer: new GestureDetector(
        onTap: () { onBannerTap(photo); },
        child: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new _GridTitleText(photo.title),
          subtitle: new _GridTitleText(photo.tags),
          trailing: new Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
      child: image,
    ));
  }
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(text),
    );
  }
}