import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  String _current = ""; // current operations + numbers thus far
  double total = 0;

  final buttonStyle = const TextStyle(
    color: Colors.blueGrey,
  );

  Widget display() {
    // display the current total + current operations
    calculate();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              child: Text(
            textAlign: TextAlign.left,
            total.toString(),
          )),
          Flexible(
              child: Text(
            textAlign: TextAlign.right,
            _current,
          ))
        ]);
  }

  void calculate() {
    total = 0;
    int start = 0; // index
    int prevOp = 0; // 0 is +, -, *, /
    for (int i = 0; i < _current.length; i++) {
      if (!_isNumeric(_current[i])) {
        int curNum = int.parse(_current.substring(start, i));
        if (prevOp == 0) {
          total += curNum;
        } else if (prevOp == 1) {
          total -= curNum;
        } else if (prevOp == 2) {
          total *= curNum;
        } else if (prevOp == 3) {
          if (curNum == 0) {
            if (kDebugMode) {
              print("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHH divide by 0");
            }
          } else {
            total /= curNum;
          }
        }
        start = i + 1;
        if (_current[i] == '+') {
          prevOp = 0;
        } else if (_current[i] == '-') {
          prevOp = 1;
        } else if (_current[i] == '*') {
          prevOp = 2;
        } else if (_current[i] == '/') {
          prevOp = 3;
        } else {
          if (kDebugMode) {
            print("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHH unchecked character");
          }
        }
      }
    }
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
      Flexible(child: display()),
      Flexible(
          child: GridButton(
              items: const [
            [
              GridButtonItem(title: '7'),
              GridButtonItem(title: '8'),
              GridButtonItem(title: '9'),
              GridButtonItem(title: '/'),
            ],
            [
              GridButtonItem(title: '4'),
              GridButtonItem(title: '5'),
              GridButtonItem(title: '6'),
              GridButtonItem(title: '*'),
            ],
            [
              GridButtonItem(title: '1'),
              GridButtonItem(title: '2'),
              GridButtonItem(title: '3'),
              GridButtonItem(title: '-'),
            ],
            [
              GridButtonItem(title: '0', flex: 2),
              GridButtonItem(title: '.'),
              GridButtonItem(title: '+'),
            ],
            [
              GridButtonItem(title: '='),
            ],
          ],
              onPressed: (dynamic val) {
                if (val != '=') {
                  _current += val;
                } else {
                  calculate();
                }
                setState(() {});
              }))
    ]);
  }
}
