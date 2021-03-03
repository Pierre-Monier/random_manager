import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _user = 3;

  void _incrementUser() {
    if (_user < 8) {
      setState(() {
        _user++;
      });
    }
  }

  void _decrementUser() {
    if (_user > 0) {
      setState(() {
        _user--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomPaint(
          painter: OpenPainter(nbrPoint: _user),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
          onPressed: _incrementUser,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _decrementUser,
          tooltip: 'Decrement',
          child: Icon(Icons.remove),
        ),
      ],)
    );
  }
}

class OpenPainter extends CustomPainter {
  OpenPainter({this.nbrPoint});
  final int nbrPoint;

  @override
  void paint(Canvas canvas, Size size) {
    print("Paint called " + nbrPoint.toString());
    var basePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    var subCirclePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    // base
    canvas.drawCircle(Offset(0, 0), 150, basePaint);

    for (int i = 0; i < nbrPoint; i++) {
      print("inside loop i = " + i.toString());
      final angle = ((2 * i) * pi) / nbrPoint;
      final x = 150 * cos(angle);
      final y = 150 * sin(angle);
      canvas.drawCircle(Offset(x, y), 10, subCirclePaint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
