import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sectionHeader.dart';
import 'dart:convert';

typedef void ArticleBannerTapCallback(Article article);

class Article{
  Article({
    this.title,
    this.url,
    this.submittedBy,
    this.submittedAt,
    this.score,
    this.tags,
    this.sport,
    this.isFavorite,
    this.favicon,
  });

  String title;
  String url;
  String submittedBy;
  String submittedAt;
  int score;
  String tags;
  String sport;
  String favicon;
  bool isFavorite;

  //bool get isValid => title != null && url != null && submittedBy != null && submittedAt != null && score != null && tags != null && sport != null;
  bool get isValid => title != null && url != null && submittedBy != null && submittedAt != null && score != null && tags != null && sport != null;

  Article.fromJson(Map value) {
    title = value['title'];
    url = value['url'];
    submittedAt = value['submitted_at'];
    submittedBy = value['submitted_by'];
    score = value['score'];
    tags = value['tags'];
    sport = value['sport'];
    isFavorite = false;
    favicon = value['favicon'];
  }
}

class TrendingArticles extends StatefulWidget{
  const TrendingArticles({ Key key }) : super(key: key, );

  @override
  _TrendingArticlesState createState() => new _TrendingArticlesState();
}

class _TrendingArticlesState extends State<TrendingArticles> {
  List<Article> articles = [];
  double sectionHeight = 250.0;
  AlignmentGeometry headerAlignment = Alignment.centerLeft;
  bool isBig = false;
  _getArticles() async {
    String url = 'http://192.168.1.105:7005/articles?team=canadiens';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    var data = JSON.decode(response);
    print(data);
    setState((){
      data.map((Map article){
        articles.add(new Article.fromJson(article));
      }).toList();
    });
  } 
  @override
  initState(){
    super.initState();
    print("init");
    _getArticles();   
  }
  void _handleSize(){
    setState((){
      if (isBig) {
        sectionHeight = 250.0;
        headerAlignment = Alignment.centerLeft;
      } else {
        sectionHeight = 450.0;
        headerAlignment = Alignment.center;
      }
      isBig = !isBig;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      height:sectionHeight,
      child: new Column(children: <Widget>[
      new SectionHeader(title: "Articles", onTap:_handleSize,alignment:headerAlignment),
      new AnimatedContainer(
        duration: const Duration(milliseconds:300),
        height:sectionHeight - 45,
        child: new ListView(
          children: articles.map((Article article) {
            return new ArticleCard(article: article);
          }).toList(),
        ),
      ),
    ]));   
  }
}
class ArticleCard extends StatelessWidget {
  final flutterWebviewPlugin = new FlutterWebviewPlugin(); 
  ArticleCard({
    Key key,
    @required this.article,
  }); //: assert(article != null && article.isValid),
       //assert(onBannerTap != null),
       //super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    final IconData icon = article.isFavorite ? Icons.star : Icons.star_border;
    return new Container(child: new ListTile(
      leading: new Image.network(article.favicon),
      title: new Text(article.title),
      trailing: new Icon(icon,color:Colors.black),
    ));
  }
}
