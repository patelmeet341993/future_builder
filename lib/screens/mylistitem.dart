import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_builder/model/Article.dart';

class MyItem extends StatelessWidget {
  final Article article;

  MyItem({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print("Click title : ${article.title}");
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: article.imageUrl!,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Time : ${article.postDateStr}"),
            SizedBox(
              height: 10,
            ),
            Text("Title : ${article.title}"),
            SizedBox(
              height: 10,
            ),
            Container(width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey,),


          ],
        ),
      ),
    );
  }
}
