import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class CustomButton extends StatelessWidget {
  final SelectedButton button;
  final String title;
  final SelectedButton selectedButton;
  final Function(SelectedButton) onButtonSelected;

  CustomButton({
    required this.button,
    required this.title,
    required this.selectedButton,
    required this.onButtonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onButtonSelected(button),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          selectedButton == button ? Colors.blue : Colors.grey,
        ),
      ),
      child: Text(title),
    );
  }
}
