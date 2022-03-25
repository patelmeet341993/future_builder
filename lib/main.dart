import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_builder/painter/CircularSliderPaint.dart';
import 'package:future_builder/screens/MainPage.dart';

import 'dart:ui' as ui;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainP(),
    );
  }
}

class MainP extends StatefulWidget {
  @override
  _MainPState createState() => _MainPState();
}

class _MainPState extends State<MainP> {

  int start=25;
  int end=-25;

  ui.Image? im;

  @override
  void initState() {
    super.initState();

    getImage("https://picsum.photos/200").then((value) {

     Future.delayed(Duration(seconds: 2),(){
       im=value;
       print("Im is null : ${im==null}");
       setState(() {});
     });

    });
  }

  Future<ui.Image> loadImage() async {
    final ByteData data = await rootBundle.load('asset/im.jpeg');
    Uint8List img = new Uint8List.view(data.buffer);
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    // //return completer.future;
    // return img;
    ui.Image im = await completer.future;
    return im;
  }


  Future<ui.Image> getImage(String path) async {
    var completer = Completer<ImageInfo>();
    var img = new NetworkImage(path);
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }



  @override
  Widget build(BuildContext context)
  {
    print('build again');
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Container(
              width: 300,
              height: 300,
              child: CircularSliderPaint(
            intervals: 100,
            init: start,
            end: end,
            im: im,
            baseColor: Colors.lightBlue,
            onSelectionChange: (start,end){
              print("Value--  :  $start | $end");
              this.start=start;
              this.end=end;
              setState(() {

              });
            },
            selectionColor: Colors.black,
            child: Text("HII1"),

          )),
        ));
  }

}
