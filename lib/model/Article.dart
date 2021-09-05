


class Article{

  String? title,postDateStr,imageUrl;

  Article(Map<dynamic,dynamic> data)
  {
    title=data["title"];
    postDateStr=data["postDateStr"];
    imageUrl=data["imageUrl"];
  }


}