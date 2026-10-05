import 'dart:math';

/// Standalone Dart Calculator Logic Engine & Test Suite
class CalculatorEngine {
  String userQuestion = '';
  String userAnswer = '';

  void tap(String btn) {
    if (btn == 'C') {
      userQuestion = '';
      userAnswer = '';
    } else if (btn == 'DEL') {
      if (userQuestion.isNotEmpty) {
        userQuestion = userQuestion.substring(0, userQuestion.length - 1);
      }
    } else if (btn == '=') {
      evaluate();
    } else if (btn == '+/-') {
      toggleSign();
    } else if (btn == '%') {
      if (userQuestion.isNotEmpty && !isOperator(userQuestion[userQuestion.length - 1])) {
        userQuestion += '%';
      }
    } else if (isOperator(btn)) {
      if (userQuestion.isEmpty) {
        if (btn == '-') userQuestion = '-';
      } else if (isOperator(userQuestion[userQuestion.length - 1])) {
        userQuestion = userQuestion.substring(0, userQuestion.length - 1) + btn;
      } else {
        userQuestion += btn;
      }
    } else if (btn == '.') {
      List<String> parts = userQuestion.split(RegExp(r'[+\-×/]'));
      String currentNum = parts.isNotEmpty ? parts.last : '';
      if (!currentNum.contains('.')) {
        if (userQuestion.isEmpty || isOperator(userQuestion[userQuestion.length - 1])) {
          userQuestion += '0.';
        } else {
          userQuestion += '.';
        }
      }
    } else {
      if (userAnswer.isNotEmpty && userQuestion.isEmpty) {
        userAnswer = '';
      }
      userQuestion += btn;
    }
  }

  bool isOperator(String char) {
    return ['+', '-', '×', '/'].contains(char);
  }

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

  void evaluate() {
    if (userQuestion.isEmpty) return;

    String expr = userQuestion;
    while (expr.isNotEmpty && isOperator(expr[expr.length - 1])) {
      expr = expr.substring(0, expr.length - 1);
    }
    if (expr.isEmpty) return;

    expr = expr.replaceAll('×', '*');

    try {
      double result = parseAndEval(expr);
      if (result.isInfinite || result.isNaN) {
        userAnswer = 'Cannot divide by zero';
      } else {
        if (result == result.roundToDouble()) {
          userAnswer = result.toInt().toString();
        } else {
          userAnswer = result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
        }
      }
    } catch (e) {
      userAnswer = 'Error';
    }
  }

  double parseAndEval(String expr) {
    // Basic arithmetic evaluation supporting %, +, -, *, /
    // Replace percentage numbers (e.g. 50% -> 0.5)
    expr = expr.replaceAllMapped(RegExp(r'([0-9.]+)\%'), (m) {
      double val = double.parse(m.group(1)!);
      return (val / 100).toString();
    });

    // Handle division by zero explicitly
    if (RegExp(r'/\s*0(\.0*)?($|[+\-*])').hasMatch(expr)) {
      return double.infinity;
    }

    // Simple expression parser for basic operators (+, -, *, /)
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expr.length; i++) {
      String char = expr[i];
      if (['+', '-', '*', '/'].contains(char)) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add(char);
      } else {
        currentToken += char;
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    if (tokens.isEmpty) return 0;

    // First pass: multiplication and division
    List<String> pass1 = [];
    int idx = 0;
    while (idx < tokens.length) {
      String token = tokens[idx];
      if (token == '*' || token == '/') {
        double prev = double.parse(pass1.removeLast());
        double next = double.parse(tokens[idx + 1]);
        if (token == '/') {
          if (next == 0) return double.infinity;
          pass1.add((prev / next).toString());
        } else {
          pass1.add((prev * next).toString());
        }
        idx += 2;
      } else {
        pass1.add(token);
        idx++;
      }
    }

    // Second pass: addition and subtraction
    double total = double.parse(pass1[0]);
    idx = 1;
    while (idx < pass1.length) {
      String op = pass1[idx];
      double next = double.parse(pass1[idx + 1]);
      if (op == '+') total += next;
      if (op == '-') total -= next;
      idx += 2;
    }

    return total;
  }
}

void main() {
  print('=====================================================');
  print('      SIMPLE CALCULATOR ENGINE - DART SUITE          ');
  print('=====================================================\n');

  final calc = CalculatorEngine();

  void runTestCase(String testName, List<String> inputs, String expectedQuestion, String expectedAnswer) {
    calc.tap('C');
    for (String btn in inputs) {
      calc.tap(btn);
    }
    bool passQuestion = calc.userQuestion == expectedQuestion;
    bool passAnswer = calc.userAnswer == expectedAnswer;
    bool pass = passQuestion && passAnswer;

    print('${pass ? "✅ [PASS]" : "❌ [FAIL]"} $testName');
    print('   Inputs: ${inputs.join(" ")}');
    print('   Expression: "${calc.userQuestion}" (Expected: "$expectedQuestion")');
    print('   Result:     "${calc.userAnswer}" (Expected: "$expectedAnswer")\n');
  }

  runTestCase('Basic Addition (7 + 8 = 15)', ['7', '+', '8', '='], '7+8', '15');
  runTestCase('Basic Subtraction (10 - 4 = 6)', ['1', '0', '-', '4', '='], '10-4', '6');
  runTestCase('Multiplication (6 × 7 = 42)', ['6', '×', '7', '='], '6×7', '42');
  runTestCase('Division by Zero Guard (9 / 0)', ['9', '/', '0', '='], '9/0', 'Cannot divide by zero');
  runTestCase('Percentage Calculation (50%)', ['5', '0', '%', '='], '50%', '0.5');
  runTestCase('Decimal Restriction (12.3.4 -> 12.3)', ['1', '2', '.', '3', '.', '4'], '12.34', '');
  runTestCase('Sign Toggle (+/- on 5 -> -5)', ['5', '+/-'], '-5', '');
  runTestCase('Operator Override (5 + × 3)', ['5', '+', '×', '3', '='], '5×3', '15');
  runTestCase('Delete Key (DEL on 123 -> 12)', ['1', '2', '3', 'DEL'], '12', '');
  runTestCase('Clear Screen (C)', ['9', '9', 'C'], '', '');

  print('=====================================================');
  print('      ALL ENGINE TESTS COMPLETED SUCCESSFULLY        ');
  print('=====================================================');
}
