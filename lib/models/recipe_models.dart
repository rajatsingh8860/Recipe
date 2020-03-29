import 'package:flutter/foundation.dart';

class RecipeModels{
  String label;
  String image;
  String source;
  String url;

  RecipeModels({this.label,this.image,this.source,this.url});
  factory RecipeModels.fromMap(Map<String,dynamic> parsedJson){
    return RecipeModels(
      url:parsedJson["url"],
      image:parsedJson["image"],
      source: parsedJson["source"],
      label: parsedJson["label"]
    );
  }
}