import 'package:flutter/material.dart';

class Todo extends StatelessWidget {
  final bool isDone;
  final String todo;
  Todo({this.isDone = false, this.todo = 'Unnamed'});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: isDone ? Colors.blue[400] : null,
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.circular(15)),
              child: Image(
                image: AssetImage(
                  'assets/images/check_icon.png',
                ),
              )),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              todo,
              style: TextStyle(
                  fontSize: 20, color: isDone ? Colors.black : Colors.grey ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
