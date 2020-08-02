import 'dart:convert';

import 'package:Recipe/screens/recipe_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/recipes.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>();

  TextEditingController textEditingController = new TextEditingController();

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=bffd12a9&app_key=676c1d7a2f791d923aaf3224adb8551a";

    var response = await http.get(url);

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      print(element.toString());
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    print("${recipes.toString()}");

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getRecipes(textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffaa4b6b),
                const Color(0xff6b6b83),
                const Color(0xff3b8d99),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Recipe",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "App",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    "What will you cook today?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Text(
                    "Just enter the ingredients and we will show the best recipe for you.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      // Padding(
                      //  padding: const EdgeInsets.symmetric(horizontal: .0),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: "Enter Ingriedients",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (textEditingController.text.isNotEmpty) {
                                    getRecipes(textEditingController.text);
                                    print("just do it");
                                  } else {
                                    print("dont do it");
                                  }
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              )),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //     ),
                      SizedBox(
                        width: 16,
                      ),
                      // Container(
                      //   child: Icon(Icons.search),
                      // )
                    ],
                  ),
                ),
                Container(
                  child: GridView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                          child: RecipieTile(
                            title: recipes[index].label,
                            desc: recipes[index].source,
                            url: recipes[index].url,
                            imgUrl: recipes[index].image,
                          ),
                        );
                      })),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Card(
            elevation: 7,
            child: Container(
              margin: EdgeInsets.all(8),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    widget.imgUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white30, Colors.white],
                            begin: FractionalOffset.centerRight,
                            end: FractionalOffset.centerLeft)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontFamily: 'Overpass'),
                          ),
                          Text(
                            widget.desc,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontFamily: 'OverpassRegular'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
