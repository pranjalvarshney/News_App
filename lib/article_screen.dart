import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './models/models.dart';


String api = "####   use your own API KEY  ####";

Future<List<Article>> fetchArticleFromSource(String source) async{
  final response =  await http.get("https://newsapi.org/v2/top-headlines?sources=$source&apiKey=$api");

  if(response.statusCode == 200){ //HTTP is OK
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  }
  else{
    throw Exception("Failed to load list");
  }
}

class ArticleScreen extends StatefulWidget {

  final Source source;

  const ArticleScreen({Key key, this.source}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {

  var listArticles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListArticles();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.account_circle),color: Colors.white,splashColor: Colors.cyanAccent, onPressed: (){}),
          title: Text(widget.source.name, style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),color: Colors.white,splashColor: Colors.cyanAccent, onPressed: (){})
          ],
          centerTitle: true,
        ),
        body: Center(
          child: RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshListArticles,
              child: FutureBuilder<List<Article>>(
                future: listArticles,
                builder: (context,snapshot){
                  if (snapshot.hasError){
                    return Text("${snapshot.error}");
                  }
                  else if(snapshot.hasData){
                    List<Article> articles = snapshot.data;
                    return ListView(
                      children: articles.map((article) => GestureDetector(
                        onTap: (){

                        },
                        child: Card(
                          elevation: 1.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
                                width: 100.0,
                                height: 100.0,
                                child: article.urlToImage != null ? Image.network(article.urlToImage) : Icon(Icons.event_note),
                              ),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: Container(
                                        margin: const EdgeInsets.only(left: 8.0,bottom: 10.0, top: 20.0),
                                        child: Text("${article.title}", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0
                                        ),),
                                      ))
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8.0),
                                    child: Text("${article.description}", style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal
                                    ),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8.0,top: 10.0, bottom: 10.0),
                                    child: Text('Time: ${article.publishedAt}', style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal
                                    ),),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      )).toList(),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
          ),
        ),

      ),
    );
  }

  Future<Null> refreshListArticles() async{

    refreshKey.currentState?.show(atTop: false);
    setState(() {
      listArticles = fetchArticleFromSource(widget.source.id);
    });
    return null;
  }

}
