import 'dart:math';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';

class Stack<T> {
  final _stack = Queue<T>();

  int get length => _stack.length;

  bool canPop() => _stack.isNotEmpty;

  void clearStack(){
    while(_stack.isNotEmpty){
      _stack.removeLast();
    }
  }

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  T peek() => _stack.last;
}


class CalculatorButton extends StatelessWidget {

  CalculatorButton({
    required this.label,
    required this.onPress,
    this.background = Colors.white,
    this.foreground = Colors.blueGrey,
    this.width = 100,
    this.height = 100
  });

  final VoidCallback onPress;
  final String label;
  final Color? background;
  final Color? foreground;
  final double width;
  final double height;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(this.width, this.height),
          shape: StadiumBorder(),
          backgroundColor: background,
          foregroundColor: foreground,
        ),
        child: Text(
            label,
            style: TextStyle(fontSize: 28)
        ),
      ),
    );
  }
}

