import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'structures.dart' as structures;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  structures.Stack _currentVal = structures.Stack();
  List<Widget> history = <Widget>[];
  TextStyle normal = const TextStyle(
  decoration: TextDecoration.none,
  color: Colors.blue,
    fontSize: 48,
    fontWeight: FontWeight.bold
  );

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
                style: normal,
              )),
          Flexible(
              child: Text(
                textAlign: TextAlign.right,
                _current,
                style: normal
              ))
        ]);
  }

  void equals() {
    history.add(Card(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 100,
              child: Text(
                textAlign: TextAlign.right,
                _current.toString(),
                style: normal,
              )
          ),
          SizedBox(
            height: 100,
            child: Text(
              textAlign: TextAlign.left,
              _currentVal.peek().toString(),
              style: normal,
          ),
          ),
        ],
      ),
      )

    ));
    _current = '';
    _currentVal.clearStack();
  }

  // recursive function that calculates mathematical string operations
  String calculate(String cur) {
    structures.Stack par = structures.Stack();

    for (int i = 0; i < cur.length; i++) {
      if (cur[i] == '(') {
        par.push(i);
      }
      if (cur[i] == ')' && par.canPop()) {
        cur = cur.substring(0, par.peek()) +
            calculate(cur.substring(par.pop() + 1, i)) +
            cur.substring(i + 1);
        i = -1;
        par = structures.Stack();
        continue;
      }
    }

    if (par.canPop()) {
      print('HELP MEEEEEEEEEEEEEEEEE');
      return _currentVal.peek();
    }

    while (true) {
      if (max(cur.indexOf('×'), cur.indexOf('÷')) == -1) {
        break;
      }
      int loc = min(cur.contains('×') ? cur.indexOf('×') : 100000000,
          cur.contains('÷') ? cur.indexOf('÷') : 100000000);
      int op = cur[loc] == '×' ? 0 : 1;
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
        cur =
            cur.substring(0, pos1 + 1) + value.toString() + cur.substring(pos2);
      } else {
        return _currentVal.peek();
      }
    }

    String prev = "HELP MEEEEEEEEEEEE";
    while (true) {
      if (max(cur.indexOf('+'), cur.indexOf('-')) == -1) {
        break;
      }
      int loc = min(cur.contains('+') ? cur.indexOf('+') : 100000000,
          cur.contains('-') ? cur.indexOf('-') : 100000000);
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
        if (num1 == '') {
          num1 = '0';
        }
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
        cur =
            cur.substring(0, pos1 + 1) + value.toString() + cur.substring(pos2);
      } else {
        return _currentVal.peek();
      }

      if (cur == prev) {
        break;
      } else {
        prev = cur;
      }
    }

    if (_isNumeric(cur)) {
      double num = double.parse(cur);
      cur = double.parse(num.toStringAsFixed(8)).toString();
    }
    print(cur);
    _currentVal.push(cur);
    return cur;
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  valuePressed(dynamic val) {
    if (val == 'Clear') {
      _current = '';
      _currentVal.clearStack();
    } else if (val == 'Backspace') {
      if (_current.isNotEmpty) {
        _current = _current.substring(0, _current.length - 1);
        _currentVal.pop();
      }
    } else if (val == '=') {
      equals();
    } else {
      _current += val;
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                return history[history.length - 1 - index];
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: display()
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                structures.CalculatorButton(label: 'C', onPress: () => valuePressed('Clear'), background: Colors.amber.shade50, foreground: Colors.amber.shade700),
                structures.CalculatorButton(label: '(', onPress: () => valuePressed('('), background: Colors.amber.shade50, foreground: Colors.amber.shade700),
                structures.CalculatorButton(label: ')', onPress: () => valuePressed(')'), background: Colors.amber.shade50, foreground: Colors.amber.shade700),
                structures.CalculatorButton(label: '÷', onPress: () => valuePressed('÷'), background: Colors.blue.shade50, foreground: Colors.blue),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                structures.CalculatorButton(label: '7', onPress: () => valuePressed('7')),
                structures.CalculatorButton(label: '8', onPress: () => valuePressed('8')),
                structures.CalculatorButton(label: '9', onPress: () => valuePressed('9')),
                structures.CalculatorButton(label: '×', onPress: () => valuePressed('×'), background: Colors.blue.shade50, foreground: Colors.blue),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                structures.CalculatorButton(label: '4', onPress: () => valuePressed('4')),
                structures.CalculatorButton(label: '5', onPress: () => valuePressed('5')),
                structures.CalculatorButton(label: '6', onPress: () => valuePressed('6')),
                structures.CalculatorButton(label: '—', onPress: () => valuePressed('-'), background: Colors.blue.shade50, foreground: Colors.blue),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                structures.CalculatorButton(label: '1', onPress: () => valuePressed('1')),
                structures.CalculatorButton(label: '2', onPress: () => valuePressed('2')),
                structures.CalculatorButton(label: '3', onPress: () => valuePressed('3')),
                structures.CalculatorButton(label: '+', onPress: () => valuePressed('+'), background: Colors.blue.shade50, foreground: Colors.blue),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                structures.CalculatorButton(label: '.', onPress: () => valuePressed('.')),
                structures.CalculatorButton(label: '0', onPress: () => valuePressed('0')),
                structures.CalculatorButton(label: '<-', onPress: () => valuePressed('Backspace'), background: Colors.grey.shade100),
                structures.CalculatorButton(label: '=', onPress: () => valuePressed('='), background: Colors.blue.shade300, foreground: Colors.white),
              ]
          ),
          /*
          Flexible(
            child: GridButton(
                items: const [
                  [
                    GridButtonItem(title: 'Clear'),
                    GridButtonItem(title: 'Backspace'),
                  ],
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
                  [
                    GridButtonItem(title: '='),
                  ],
                ],
                onPressed: (dynamic val) {
                  if (val == 'Clear') {
                    _current = '';
                    _currentVal.clearStack();
                  } else if (val == 'Backspace') {
                    if (_current.isNotEmpty) {
                      _current = _current.substring(0, _current.length - 1);
                      _currentVal.pop();
                    }
                  } else if (val == '=') {
                    equals();
                  } else {
                    _current += val;
                  }
                  setState(() {});
                }),
          )*/
        ]);
  }
}

