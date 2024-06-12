import 'package:flutter/material.dart';
import 'package:to_do_app/components/to_do_button.dart';

class DialogBox extends StatefulWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final TextEditingController dateController;
  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
      required this.dateController});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a New Task",
              ),
            ),
            TextField(
              controller: widget.dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select a Date",
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context);
              },
            ),
            //buttons => Save + Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  name: "Save",
                  onPressed: widget.onSave,
                ),
                const SizedBox(width: 10),
                MyButton(
                  name: "Cancel",
                  onPressed: widget.onCancel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
