import 'dart:convert';
import 'package:Recipe/views/receipe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Recipe/models/recipe_models.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget{
   @override
   _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  List<RecipeModels> recipes = new List<RecipeModels>();
  TextEditingController textEditingController = TextEditingController();
  String applicationId='85ea5f54';
  String applicationKey='c82ea328e27d33ff75c39f93b39fee1b';

  getRecipe(String query) async{
    String url="https://api.edamam.com/search?q=$query&app_id=${applicationId}&app_key=${applicationKey}";
    var response= await http.get(url);
  
    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element){
      RecipeModels recipeModels= new RecipeModels();
      recipeModels=RecipeModels.fromMap(element["recipe"]);
      recipes.add(recipeModels);
    });
    setState(() {});
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Stack (
         children: <Widget>[
           Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             decoration:new BoxDecoration(
               gradient: LinearGradient(
                 colors: [
                   const Color(0xff213A50),
                   const Color(0xff071930)
                 ])
             ),


           ),
           SingleChildScrollView(
                        child: new Container(
               padding:EdgeInsets.symmetric(horizontal: 10,vertical: 60),
               child:new Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   new Row (
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text("Food",style: TextStyle(
                         fontSize:22,
                     fontWeight: FontWeight.w500,
                     color: Colors.white
                       ),),
                     Text("Recipe",style: TextStyle(
                       fontSize:22,
                     fontWeight: FontWeight.w500,
                       color:Colors.blue
                     ))
                     ],
                     
                   ),
                   new SizedBox(
                     height:30
                   ),
                   Text("What will you cook today",style: TextStyle(
                     fontSize: 20,
                     color:Colors.white
                   ),),
                   SizedBox(height:8),
                   Text("Just enter ingredients you have and we will show the best recipe for you",style: TextStyle(
                     fontSize:15,
                     color: Colors.white
                   ),),
                   SizedBox(height:30),
                   new Container(
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child:new TextField(
                            controller: textEditingController,
                            decoration:InputDecoration(
                              hintText:"Enter Ingredients",
                              hintStyle:TextStyle(
                                fontSize:18,
                                color: Colors.white.withOpacity(0.4)
                              ),
                          
                            ),
                            style: TextStyle(
                              fontSize:18,
                              color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(width:36),
                       
                                 new Container(
                            child:GestureDetector(
                              onTap: (){
                            if(textEditingController.text.isNotEmpty){
                              getRecipe(textEditingController.text);
                              print("Do it");
                            } else{
                              print("Enter ingredients first");
                            }
                              },
                            
                              child: Container
                              (
                                decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(3),
                                  gradient: LinearGradient(
                                    colors:[
                                  const Color(0xffA2834D),
                                  const Color(0xff8C9A5F)
                                    ]
                                  )
                                ),
                                child: Icon(Icons.search,color: Colors.white,))
                              )
                          ),
                      
                      ],
                    ),
                   ),
                   new Container(
                       child: new GridView(
                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       physics: ClampingScrollPhysics(),
                       gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
                         maxCrossAxisExtent:200,mainAxisSpacing: 10.0 ),
                         children: List.generate(recipes.length, (index) {
                           return GridTile(
                             child: RecipieTile(
                               title: recipes[index].label,
                               desc: recipes[index].source,
                               imgUrl: recipes[index].image,
                               url:recipes[index].url
                             )
                           );
                          
                           
                         }),
                         
                        ),
                   ),
                      

                 ],
               ),
             ),
           )
         ]
      )
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
    var gestureDetector = GestureDetector(
          onTap: () {
            
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
          },
          child: new Container(
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
                              ),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
  
        );
    return Wrap(
      children: <Widget>[
        gestureDetector,
      ],
    );
  }
}





  