import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  int _counter = 0;
  int _oldCount = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation =
        Tween<double>(begin: 0, end: math.pi).animate(_animationController);

    _animation.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCounter() async {
    if (!_animationController.isAnimating) {
      _counter++;
      await _animationController.forward();
      _oldCount = _counter;
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _textWidget = Center(
        child: Text(
            (_animation.value >= math.pi / 2)
                ? _counter.toString()
                : _oldCount.toString(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 96,
                fontWeight: FontWeight.bold)));

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 98,
                        width: 200,
                        color: Colors.grey[900],
                        child: Center(
                            child: Text(_counter.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 96,
                                    fontWeight: FontWeight.bold))),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 4,
                      ),
                      Container(
                        height: 98,
                        width: 200,
                        color: Colors.grey[900],
                        child: Center(
                            child: Text(_oldCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 96,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                      animation: _animation,
                      child: Center(
                        child: Container(
                          height: 100,
                          width: 200,
                          color: Colors.grey[900],
                          child: (_animation.value >= math.pi / 2)
                              ? Transform(
                                  transform: Matrix4.rotationX(math.pi),
                                  child: _textWidget,
                                )
                              : _textWidget,
                        ),
                      ),
                      builder: <ValueWidgetBuilder>(BuildContext context,
                          Widget? child) {
                        return Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(_animation.value),
                          child: child,
                        );
                      })
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            child: Ink(
              width: 60,
              height: 60,
              decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 40,
                onPressed: _updateCounter,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
