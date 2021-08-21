import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import './todowidget.dart';
import './models/task.dart';
import './models/todo.dart';

class TaskPage extends StatefulWidget {
  final dynamic task;
  String _taskTitle = '';
  String _taskDesc = '';
  TaskPage({required this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  FocusNode _titleNode = FocusNode();
  FocusNode _descNode = FocusNode();
  FocusNode _todoNode = FocusNode();
  int _taskID = 0;
  bool _visibleContent = false;
  TextEditingController _todoText = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleNode.requestFocus();
    if (widget.task == 0) {
      // its new
      widget._taskTitle = '';
      widget._taskDesc = '';
    } else {
      // retrieve it
      _visibleContent = true;
      widget._taskTitle = widget.task.title;
      _taskID = widget.task.id;
      widget._taskDesc = widget.task.desc;
    }
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descNode.dispose();
    _todoNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image(
                            image:
                                AssetImage('assets/images/back_arrow_icon.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _titleNode,
                        onSubmitted: (value) async {
                          if (value.trim().length != 0) {
                            // checked is it 0? if is 0 then it is a new widget otherwise it was existed
                            // lets insert data
                            if (widget.task == 0) {
                              // it is new. Create it!
                              DatabaseHelper _dbHelper = DatabaseHelper();
                              Task _newTask = Task(title: value, desc: '');
                              _taskID = await _dbHelper.insertTask(_newTask);
                              // print(_taskID);
                              setState(() {
                                _visibleContent = true;
                                widget._taskTitle = value;
                              });
                            } else {
                              // we have to update the new title
                              DatabaseHelper _dbHelper = DatabaseHelper();
                              await _dbHelper.updateTask(value, _taskID);
                              // print("update success");
                            }
                          }
                          _descNode.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = widget._taskTitle,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _visibleContent,
                  child: Container(
                    height: 60,
                    child: ListView(children: [
                      TextField(
                        controller: TextEditingController()
                          ..text = widget._taskDesc,
                        onSubmitted: (value) {
                          DatabaseHelper _dbHelper = DatabaseHelper();
                          _dbHelper.updateDesc(value, _taskID);
                          setState(() {
                            widget._taskDesc = value;
                          });
                          _todoNode.requestFocus();
                        },
                        focusNode: _descNode,
                        decoration: InputDecoration(
                            hintText: 'Description',
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            border: InputBorder.none),
                        style: TextStyle(fontSize: 21),
                      ),
                    ]),
                  ),
                ),
                Visibility(
                  visible: _visibleContent,
                  child: Expanded(
                      child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTodo(_taskID),
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      DatabaseHelper _dbHelper =
                                          DatabaseHelper();
                                      if (snapshot.data[index].isDone == 1) {
                                        await _dbHelper.updateTodo(
                                            0, snapshot.data[index].id);
                                      } else {
                                        await _dbHelper.updateTodo(
                                            1, snapshot.data[index].id);
                                      }
                                      // print(snapshot.data[index].isDone);
                                      setState(() {});
                                    },
                                    child: Todo(
                                      isDone: snapshot.data[index].isDone == 1
                                          ? true
                                          : false,
                                      todo: snapshot.data[index].title,
                                    ),
                                  );
                                });
                          })),
                ),
                Visibility(
                  visible: _visibleContent,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: null,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image(
                                image: AssetImage(
                                  'assets/images/check_icon.png',
                                ),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController()..text = '',
                            focusNode: _todoNode,
                            onSubmitted: (value) async {
                              if (value.trim().length != 0) {
                                if (_taskID != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  TodoList _newTodo = TodoList(
                                      title: value, taskID: _taskID, isDone: 0);
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  _todoNode.requestFocus();
                                }
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter a new Todo here..'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            cursorColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _visibleContent,
              child: Positioned(
                  right: 0,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskID != 0) {
                        DatabaseHelper _dbHelper = DatabaseHelper();
                        await _dbHelper.deleteTask(_taskID);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Image(
                        image: AssetImage('assets/images/delete_icon.png'),
                      ),
                    ),
                  )),
            )
          ]),
        )),
      ),
    );
  }
}
