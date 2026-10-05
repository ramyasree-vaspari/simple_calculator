import 'package:flutter/material.dart';

/// Class storing the 20 calculator button labels in row-by-row grid order.
class CalculatorButtons {
  static const List<String> buttons = [
    'C', '+/-', '%', 'DEL',
    '7', '8',   '9', '/',
    '4', '5',   '6', '×',
    '1', '2',   '3', '-',
    '0', '.',   '=', '+',
  ];
}

/// Reusable widget for calculator buttons.
/// Encapsulates styling, border decoration, background color, text formatting, and tap handling.
class MyButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String buttonText;
  final VoidCallback? buttonTapped;

  const MyButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText,
    this.buttonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: buttonTapped,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
