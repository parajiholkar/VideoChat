import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTab;
  final String text ;
  const MyButton({super.key, this.onTab, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { onTab; },
      child: Text(text),
    );
  }
}
