import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_builder/model/Article.dart';
import 'package:future_builder/screens/mylistitem.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Article> articles = [];
  late Future<bool> _future;

  Future<bool> getData() async {
    print("Api call");
    try {
      var url = Uri.parse(
          'https://www.pinkvilla.com/feed/section.php?type=content_entertainment');
      var response = await http.get(url);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      String data = response.body;

      var parseData = jsonDecode(data);

      for (Map m in parseData) {
        articles.add(Article(m));
      }
      print("Length of data: ${articles.length}");
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: mainBody(),
    ));
  }

  Widget mainBody() {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitThreeBounce(
              color: Colors.lightBlue,
              size: 70,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return getListView();
          } else
            return Container(
              child: Text("error"),
            );
        });
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          print("Index : $index");
          return MyItem(article: articles[index]);
        });
  }
}
