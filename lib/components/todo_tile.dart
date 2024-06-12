import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatefulWidget {
  final String name;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? editFunction;
  final String date;

  const ToDoTile({
    super.key,
    required this.name,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.date,
    required this.editFunction,
  });

  @override
  _ToDoTileState createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  bool _isImportant = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isImportant ? Colors.red : Colors.black26,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: widget.taskCompleted,
                    onChanged: widget.onChanged,
                    activeColor: Colors.black,
                  ),

                  // Task Name and Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            decoration: widget.taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Icon
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => widget.editFunction?.call(context),
                    color: Colors.black,
                  ),

                  // Radio button for Importance
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isImportant = !_isImportant;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isImportant
                            ? const Icon(Icons.radio_button_checked,
                                color: Colors.white)
                            : const Icon(Icons.radio_button_off,
                                color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              // Display "Important" when radio button is selected
              if (_isImportant)
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    'Important',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
