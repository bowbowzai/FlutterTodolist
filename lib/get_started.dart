import 'package:flutter/material.dart';

class GetStart extends StatelessWidget {
  final String title;
  final String desc;
  GetStart(
      {this.title = '(Unnamed Title)',
      this.desc =
          'Hello User!! Welcome to my TodoList(Although i just doing the same thing on youtube --> https://www.youtube.com/watch?v=mOiXndQAZpw&list=PLGCjwl1RrtcSlUrd_-Z-924b3ahWISiDh <-- cuz im a beginner)'});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 15,
          ),
          Text(
            desc,
            style:
                TextStyle(fontSize: 15, height: 1.3, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
