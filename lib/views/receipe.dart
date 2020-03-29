import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class RecipeView extends StatefulWidget{

  final String postUrl;
  RecipeView({this.postUrl});
   @override
   _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView>{
  String finalUrl;
  final Completer<WebViewController> _controller  = new Completer<WebViewController>();
  @override
  void initState() {
    if(widget.postUrl.contains("http://")){
            finalUrl = widget.postUrl.replaceAll("http://","https://");
    }
    else{
      finalUrl = widget.postUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body:new Container(
      //padding:EdgeInsets.symmetric(horizontal: 10,vertical: 60),
      child: Column(
      children: <Widget>[
        new Container(
         decoration:new BoxDecoration(
               gradient: LinearGradient(
                 colors: [
                   const Color(0xff213A50),
                   const Color(0xff071930)
                 ])
             ),
          padding:EdgeInsets.only(top:60,right: 20,left:20,bottom:20),
          width:MediaQuery.of(context).size.width,
          child: new Row (
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
        ),
       SingleChildScrollView(
                child: Container(
            height:MediaQuery.of(context).size.height-110,
            width:MediaQuery.of(context).size.width,
                  child: WebView(
             initialUrl:finalUrl,
             javascriptMode: JavascriptMode.unrestricted,
             onWebViewCreated: (WebViewController webViewController){
               setState(() {
                 _controller.complete(webViewController);
               });

             },

           ),
         ),
       )
      ]
      ),
    ),
    
    );
  }
}