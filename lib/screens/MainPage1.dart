import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_builder/model/Article.dart';
import 'package:future_builder/screens/mylistitem.dart';
import 'package:http/http.dart' as http;

class MainPage1 extends StatefulWidget {
  @override
  _MainPage1State createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {

  late Future<List<Article>> _future;

  Future<List<Article>> getData() async {
    print("Api call");
    try {
      var url = Uri.parse(
          'https://www.pinkvilla.com/feed/section.php?type=content_entertainment');
      var response = await http.get(url);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      String data = response.body;

      var parseData = jsonDecode(data);
      List<Article> list=[];
      for (Map m in parseData) {
        list.add(Article(m));
      }
      print("Length of data: ${list.length}");
      return list;
    } catch (e) {
      return [];
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
    return FutureBuilder<List<Article>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitThreeBounce(
              color: Colors.lightBlue,
              size: 70,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return getListView(snapshot.data!);
          } else
            return Container(
              child: Text("error"),
            );
        });
  }

  Widget getListView(List<Article> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          print("Index : $index");
          return MyItem(article: list[index]);
        });
  }
}
