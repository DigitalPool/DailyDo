import 'package:daily_do/utils/my_button.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      content: Container(
          height: 120,
          child: Column(
            children: [
              //get user input
              TextField(
                controller: controller,
                decoration:
                    InputDecoration(hintText: "type to add a new task ..."),
              ),
              //buttons = save & cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(text: "Save", onPressed: onSave),
                  const SizedBox(width: 8),
                  MyButton(text: "Cancel", onPressed: onCancel),
                ],
              ),
            ],
          )),
    );
  }
}
