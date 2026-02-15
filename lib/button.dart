import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Icon(icon),
    );
  }
}