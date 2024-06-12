import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  const MyButton({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const BeveledRectangleBorder(),
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(name),
    );
  }
}
