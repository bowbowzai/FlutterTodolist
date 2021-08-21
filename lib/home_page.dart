import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import './get_started.dart';
import './taskpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.grey[200],
        padding: EdgeInsets.only(top: 30, right: 30, left: 30),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  child: Image(
                    image: AssetImage('assets/images/rem.png'),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTask(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                                task: snapshot.data[index])))
                                    .then((value) => setState(() => {}));
                              },
                              child: GetStart(
                                title: snapshot.data[index].title,
                                desc: snapshot.data[index].desc,
                              ));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPage(task: 0)))
                      .then((value) => setState(() {}));
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[300],
                  ),
                  child: Image(
                    image: AssetImage('assets/images/add_icon.png'),
                  ),
                ),
              ),
              right: 0,
              bottom: 10,
            )
          ],
        ),
      ),
    ));
  }
}
