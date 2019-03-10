import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/article_screen.dart';
import './models/models.dart';


String api = "####   use your own API KEY  ####";

Future<List<Source>> fetchNewsSource() async{
  final response =  await http.get("https://newsapi.org/v2/sources?apiKey=$api");

  if(response.statusCode == 200){ //HTTP is OK
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  }
  else{
    throw Exception("Failed to load list");
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  var listSources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  int selectedIndex = 0;
  final bottomNaviagtionOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListSources();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Now News", style: new TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.account_circle), onPressed: (){} , splashColor: Colors.cyanAccent, tooltip: "Account", color: Colors.white),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){}, splashColor: Colors.cyanAccent, tooltip: "Search", color: Colors.white,)
        ],
      ),
      body: Center(
        child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Source>>(
                        builder: (context, snapshot){
                          if(snapshot.hasError){
                            Text("Error:  ${snapshot.error}");
                          }
                          else if(snapshot.hasData){
                            List<Source> sources = snapshot.data;
                            return new ListView(
                              children: sources.map((source) => GestureDetector(
                                onTap: (){
                                  
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen(source: source)));
                                  
                                },
                                child: Card(
                                    elevation: 1.0,
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 12.0),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                            height: 100,
                                            width: 100,
                                            child: Icon(Icons.event_note),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                    margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                                                    child: Text("${source.name}", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),

                                        ],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 5.0, right: 10),
                                                  child: Text("${source.description}", style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 5.0, right: 10, bottom: 10.0),
                                                  child: Text("Category: ${source.category}", style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                ),

                                  ],
                                            ),
                                          ),
                                          ],
                                      ),

                                  ),
                                )).toList(),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      future: listSources,

                    ),
            onRefresh: refreshListSources,
      ),
    ),
    );
  }

  Future<Null> refreshListSources() async{

   refreshKey.currentState?.show(atTop: false);
   setState(() {
     listSources = fetchNewsSource();
   });
   return null;
  }
}
