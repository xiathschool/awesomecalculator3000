import 'dart:math';

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
  String _currentVal = '0';
  final buttonStyle = const TextStyle(
    color: Colors.blueGrey,
  );

  Widget display() {
    // display the current total + current operations
    String total = calculate(_current);
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

  // recursive function that calculates mathematical string operations
  String calculate(String cur) {
    while (true) {
      int parenth = cur.indexOf('(');
      if (parenth == -1) {
        break;
      }
      int endParenth = cur.lastIndexOf(')');
      if (endParenth == -1) {
        print("AHHHHHHHHHHHHHHHHH incorrect syntax: no ending parenthesis");
        return _currentVal;
      }
      String value = calculate(cur.substring(parenth + 1, endParenth));
      cur = cur.substring(0, parenth) + value.toString() + cur.substring(endParenth + 1);
    }

    while (true) {
      if (max(cur.indexOf('*'), cur.indexOf('/')) == -1) {
        break;
      }
      int loc = min(cur.contains('*') ? cur.indexOf('*') : 100000000, cur.contains('/') ? cur.indexOf('/') : 100000000);
      int op = cur[loc] == '*' ? 0 : 1;
      int pos1 = -1;
      String num1 = '';
      int pos2 = -1;
      String num2 = '';
      for (int j = loc - 1; j >= 0; j--) {
        if (cur[j] != '.' && !_isNumeric(cur[j])) {
          pos1 = j;
          num1 = cur.substring(j + 1, loc);
          break;
        }
      }

      if (num1 == '') {
        pos1 = -1;
        num1 = cur.substring(0, loc);
      }

      for (int j = loc + 1; j < cur.length; j++) {
        if (cur[j] != '.' && !_isNumeric(cur[j])) {
          pos2 = j;
          num2 = cur.substring(loc + 1, j);
          break;
        }
      }

      if (num2 == '') {
        pos2 = cur.length;
        num2 = cur.substring(loc + 1, pos2);
      }

      double value = 0;
      if (_isNumeric(num1) && _isNumeric(num2)) {
        if (op == 0) {
          value = double.parse(num1) * double.parse(num2);
        } else {
          value = double.parse(num1) / double.parse(num2);
        }
        cur = cur.substring(0, pos1 + 1) + value.toString() + cur.substring(pos2);
      } else {
        return _currentVal;
      }
    }


    while (true) {
      if (max(cur.indexOf('+'), cur.indexOf('-')) == -1) {
        break;
      }
      int loc = min(cur.contains('+') ? cur.indexOf('+') : 100000000, cur.contains('-') ? cur.indexOf('-') : 100000000);
      int op = cur[loc] == '+' ? 0 : 1;
      int pos1 = -1;
      String num1 = '';
      int pos2 = -1;
      String num2 = '';
      for (int j = loc - 1; j >= 0; j--) {
        if (cur[j] != '.' && !_isNumeric(cur[j])) {
          pos1 = j;
          num1 = cur.substring(j + 1, loc);
          break;
        }
      }

      if (num1 == '') {
        pos1 = -1;
        num1 = cur.substring(0, loc);
      }

      for (int j = loc + 1; j < cur.length; j++) {
        if (cur[j] != '.' && !_isNumeric(cur[j])) {
          pos2 = j;
          num2 = cur.substring(loc + 1, j);
          break;
        }
      }

      if (num2 == '') {
        pos2 = cur.length;
        num2 = cur.substring(loc + 1, pos2);
      }

      double value = 0;
      if (_isNumeric(num1) && _isNumeric(num2)) {
        if (op == 0) {
          value = double.parse(num1) + double.parse(num2);
        } else {
          value = double.parse(num1) - double.parse(num2);
        }
        cur = cur.substring(0, pos1 + 1) + value.toString() + cur.substring(pos2);
      } else {
        return _currentVal;
      }
    }
    if (_isNumeric(cur)) {
      double num = double.parse(cur);
      cur = double.parse(num.toStringAsFixed(8)).toString();
    }
    print(cur);
    _currentVal = cur;
    return cur;
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
              GridButtonItem(title: '('),
              GridButtonItem(title: ')'),
            ],
          ],
              onPressed: (dynamic val) {
                if (val != '=') {
                  _current += val;
                }
                setState(() {});
              }))
    ]);
  }
}
