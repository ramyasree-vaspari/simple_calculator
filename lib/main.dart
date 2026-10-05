import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

/// Main Calculator Screen managing state and UI
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var userQuestion = '';
  var userAnswer = '';

  /// Returns the background color for a given button based on design specs
  Color getButtonColor(String buttonText) {
    if (['C', '+/-', '%', 'DEL'].contains(buttonText)) {
      return const Color(0xFFE1F5FE); // Light blue (#E1F5FE)
    } else if (['/', '×', '-', '+'].contains(buttonText)) {
      return const Color(0xFF448AFF); // Blue (#448AFF)
    } else if (buttonText == '=') {
      return const Color(0xFFFF8800); // Orange (#FF8800)
    } else {
      return const Color(0xFFFFFFFF); // White (#FFFFFF) for numbers & decimal
    }
  }

  /// Returns text color for buttons (white for operators/equals, black for numbers/functions)
  Color getTextColor(String buttonText) {
    if (['/', '×', '-', '+', '='].contains(buttonText)) {
      return Colors.white;
    }
    return Colors.black;
  }

  /// Main handler for button taps
  void onButtonTapped(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        userQuestion = '';
        userAnswer = '';
      } else if (buttonText == 'DEL') {
        if (userQuestion.isNotEmpty) {
          userQuestion = userQuestion.substring(0, userQuestion.length - 1);
        }
      } else if (buttonText == '=') {
        equalPressed();
      } else if (buttonText == '+/-') {
        toggleSign();
      } else if (buttonText == '%') {
        appendPercentage();
      } else if (['+', '-', '×', '/'].contains(buttonText)) {
        appendOperator(buttonText);
      } else if (buttonText == '.') {
        appendDecimal();
      } else {
        // Numbers 0-9
        appendNumber(buttonText);
      }
    });
  }

  /// Appends a digit, resetting previous result if starting fresh
  void appendNumber(String number) {
    if (userAnswer.isNotEmpty && userQuestion.isEmpty) {
      userAnswer = '';
    }
    userQuestion += number;
  }

  /// Appends a decimal point, ensuring no multiple decimals within the active number
  void appendDecimal() {
    List<String> parts = userQuestion.split(RegExp(r'[+\-×/]'));
    String currentNumber = parts.isNotEmpty ? parts.last : '';

    if (!currentNumber.contains('.')) {
      if (userQuestion.isEmpty || isOperator(userQuestion[userQuestion.length - 1])) {
        userQuestion += '0.';
      } else {
        userQuestion += '.';
      }
    }
  }

  /// Appends arithmetic operator, replacing trailing operator if user switches operators
  void appendOperator(String op) {
    if (userQuestion.isEmpty) {
      if (op == '-') {
        userQuestion = '-';
      }
      return;
    }

    String lastChar = userQuestion[userQuestion.length - 1];
    if (isOperator(lastChar)) {
      // Replace existing operator
      userQuestion = userQuestion.substring(0, userQuestion.length - 1) + op;
    } else {
      userQuestion += op;
    }
  }

  /// Toggles sign (+/-) of the current active number
  void toggleSign() {
    if (userQuestion.isEmpty) {
      userQuestion = '-';
      return;
    }

    final regExp = RegExp(r'([+\-×/])?([0-9.]+)$');
    final match = regExp.firstMatch(userQuestion);

    if (match != null) {
      String? op = match.group(1);
      String number = match.group(2)!;
      int startIdx = match.start;
      String prefix = userQuestion.substring(0, startIdx);

      if (op == '-') {
        userQuestion = '$prefix+ $number';
      } else if (op == '+') {
        userQuestion = '$prefix- $number';
      } else if (op == null && prefix.isEmpty) {
        userQuestion = '-$number';
      } else if (op == null && prefix == '-') {
        userQuestion = number;
      } else {
        userQuestion = '$prefix${op ?? ''}-$number';
      }
    }
  }

  /// Appends percentage operator
  void appendPercentage() {
    if (userQuestion.isNotEmpty && !isOperator(userQuestion[userQuestion.length - 1])) {
      userQuestion += '%';
    }
  }

  /// Helper to check if character is an arithmetic operator
  bool isOperator(String x) {
    return ['+', '-', '×', '/'].contains(x);
  }

  /// Evaluates expression using math_expressions library
  void equalPressed() {
    if (userQuestion.isEmpty) return;

    String finalQuestion = userQuestion;

    // Trim trailing operators if user taps '=' early
    while (finalQuestion.isNotEmpty && isOperator(finalQuestion[finalQuestion.length - 1])) {
      finalQuestion = finalQuestion.substring(0, finalQuestion.length - 1);
    }

    if (finalQuestion.isEmpty) return;

    // Convert UI operators to standard math expression format
    finalQuestion = finalQuestion.replaceAll('×', '*');
    finalQuestion = finalQuestion.replaceAll('%', '/100');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) {
        userAnswer = 'Cannot divide by zero';
      } else {
        // Format integer output cleanly vs decimal precision
        if (eval == eval.roundToDouble() && !eval.toString().contains('e')) {
          userAnswer = eval.toInt().toString();
        } else {
          userAnswer = eval
              .toStringAsFixed(8)
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), '');
        }
      }
    } catch (e) {
      userAnswer = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar matching blue theme (#2196F3) and left title
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Display Section - Dark grey background (#606260)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF606260),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAlignment.end,
                  children: <Widget>[
                    // User Expression Display
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        userQuestion,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    // Calculated Result Display
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        userAnswer,
                        style: const TextStyle(
                          fontSize: 44,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Keypad Section - 4-Column Grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CalculatorButtons.buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  String btnText = CalculatorButtons.buttons[index];
                  return MyButton(
                    buttonText: btnText,
                    color: getButtonColor(btnText),
                    textColor: getTextColor(btnText),
                    buttonTapped: () => onButtonTapped(btnText),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
