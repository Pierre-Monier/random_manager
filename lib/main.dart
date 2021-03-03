import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const double baseCircleRadius = 150;
  static const centerOffset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Random manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _user = 3;
  List<Offset> _subCirclesOffsets;
  int _nbrIteration = 1;
  Animation<double> _animation;
  AnimationController _controller;
  Offset _endpoint;
  Offset _currentLine;

  @override
  void initState() {
    super.initState();

    _subCirclesOffsets = _getSubCirclesOffsets();
    updateEndPoint();



    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    Tween<double> _rotationTween = Tween(begin: -pi, end: pi);

    _animation = _rotationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
        if ((_currentLine - _endpoint).distance < 5) {
          //target touched
          if (_nbrIteration > 0) {
            _nbrIteration--;
          } else {
            _controller.stop();
            _nbrIteration = 1;
            updateEndPoint();
          }
        }

      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("upperBound : " + _controller.upperBound.toString() + " lowerBound : " + _controller.lowerBound.toString());
          _controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  List<Offset> _getSubCirclesOffsets() {
    List<Offset> offsets = [];
    for (int i = 0; i < _user; i++) {
      final angle = ((2 * i) * pi) / _user;
      print("angle : " + angle.toString());
      final x = MyApp.baseCircleRadius * cos(angle);
      final y = MyApp.baseCircleRadius * sin(angle);
      offsets.add(Offset(x, y));
    }

    return offsets;
  }

  void _incrementUser() {
    if (_user < 8) {
      setState(() {
        _user++;
        _subCirclesOffsets = _getSubCirclesOffsets();
        updateEndPoint();
      });
    }
  }

  void _decrementUser() {
    if (_user > 0) {
      setState(() {
        _user--;
        _subCirclesOffsets = _getSubCirclesOffsets();
        updateEndPoint();
      });
    }
  }

  void _startSelection() {
    if (_controller != null && !_controller.isAnimating) {
      _controller.forward();
    } else if (_controller != null) {
      _controller.stop();
    }
    setState(() {});
  }

  void updateCurrentLine(Offset newOffset) {
    _currentLine = newOffset;
  }
  
  void updateEndPoint() {
    if (_subCirclesOffsets != null) {
      _endpoint = _subCirclesOffsets[Random().nextInt(_subCirclesOffsets.length -1)];
    } else {
      throw Exception("Trying to get endpoint on a null offsets array");
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
          painter: CirclesPainter(nbrPoint: _user, subCirclesOffsets: this._subCirclesOffsets),
          foregroundPainter: CursorPainter(radians: _animation.value, parent: this),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
          onPressed: _startSelection,
          tooltip: 'Toggle Animation',
          child: _controller.isAnimating ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        ),
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

class CirclesPainter extends CustomPainter {
  CirclesPainter({this.nbrPoint, this.subCirclesOffsets});
  final int nbrPoint;
  final List<Offset> subCirclesOffsets;

  @override
  void paint(Canvas canvas, Size size) {
    var basePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    var subCirclePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(MyApp.centerOffset, MyApp.baseCircleRadius, basePaint);
    
    subCirclesOffsets.forEach((offset) {
      canvas.drawCircle(offset, 20, subCirclePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CursorPainter extends CustomPainter {
  CursorPainter({this.radians, this.parent});
  final double radians;
  final _MyHomePageState parent;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Offset pointOnCircle = Offset(
      MyApp.baseCircleRadius * cos(radians),
      MyApp.baseCircleRadius * sin(radians),
    );

    this.parent.updateCurrentLine(pointOnCircle);

    canvas.drawLine(MyApp.centerOffset, pointOnCircle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
