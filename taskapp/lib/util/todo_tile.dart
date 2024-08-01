import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function()? editFunction;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(20),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.yellow[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.red,
              ),
              Text(
                taskName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: editFunction,
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
