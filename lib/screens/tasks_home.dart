import 'package:flutter/material.dart';
import 'package:journal_todo/models/task_model.dart';
import 'package:journal_todo/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController titleCtrl = TextEditingController();
TextEditingController contentCtrl = TextEditingController();

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TEntryProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          TopBar(),
          Expanded(
            child: Container(
              //color: Colors.white60,
              padding: EdgeInsets.all(20.0),
              child: StreamBuilder<List<Task>>(
                stream: taskProvider.tasks,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            snapshot.data[index].title,
                          ),
                          subtitle: Text(
                            snapshot.data[index].content,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.check_box_outlined),
                            color: Colors.cyanAccent,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    elevation: 15,
                                    child: Container(
                                      height: 175,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 36,
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Are you really done with this task?',
                                              style:
                                                  TextStyle(color: Colors.cyan),
                                            ),
                                            SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    taskProvider.removeTask(
                                                        snapshot.data[index]
                                                            .taskID);
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    Fluttertoast.showToast(
                                                      msg: 'Task done!',
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                    );
                                                  },
                                                  child: Text('Yes'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.cyanAccent,
                                                    onPrimary: Colors.black,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: Text('No'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.cyanAccent,
                                                    onPrimary: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              // taskProvider
                              //     .removeTask(snapshot.data[index].taskID);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // child: StreamBuilder(
              //   stream:
              //       FirebaseFirestore.instance.collection('tasks').snapshots(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (!snapshot.hasData) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }

              //     return ListView(
              //       children: snapshot.data.docs.map((document) {
              //         return Container(
              //           child: Card(
              //             child: ListTile(
              //               onTap: () {},
              //               title: Text(document['title']),
              //               subtitle: Text(document['content']),
              //               trailing: IconButton(
              //                 icon: Icon(
              //                   Icons.delete,
              //                   color: Colors.red,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * .80,
                padding: EdgeInsets.all(36.0),
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     Text('ADD TASK'),
                    //     IconButton(
                    //         icon: Icon(Icons.calendar_today),
                    //         onPressed: () {
                    //           _taskDate(context, taskProvider).then((value) {
                    //             if (value != null) {
                    //               taskProvider.changeDate = value;
                    //             }
                    //           });
                    //         })
                    //   ],
                    // ),
                    Text(
                      'ADD TASK',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            // bottomLeft
                            offset: Offset(-1, -1),
                          ),
                          Shadow(
                            // bottomRight
                            offset: Offset(1, -1),
                          ),
                          Shadow(
                            // topRight
                            offset: Offset(1, 1),
                          ),
                          Shadow(
                            // topLeft
                            offset: Offset(-1, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleCtrl,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (val) {
                              val = titleCtrl.text;
                              if (val.isEmpty)
                                return 'This field is required';
                              else
                                return null;
                            },
                            onChanged: (String value) =>
                                taskProvider.changeTaskTitle = value,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: contentCtrl,
                            maxLines: 12,
                            minLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              labelText: 'Write Content',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (val) {
                              contentCtrl.text = val;
                              if (val.isEmpty)
                                return 'This field is required';
                              else
                                return null;
                            },
                            onChanged: (String value) =>
                                taskProvider.changeTaskContent = value,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.cyanAccent,
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  context.read<TEntryProvider>().saveTask();
                                  Navigator.of(context).pop();
                                  titleCtrl.text = '';
                                  contentCtrl.text = '';
                                },
                              ),
                              ElevatedButton(
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.cyanAccent,
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  titleCtrl.text = '';
                                  contentCtrl.text = '';
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyanAccent,
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 12, horizontal: 3),
        height: 100,
        decoration: BoxDecoration(
            //color: Colors.cyanAccent,
            // borderRadius: BorderRadius.only(
            //   bottomLeft: Radius.circular(20),
            //   bottomRight: Radius.circular(20),
            //   topRight: Radius.circular(20),
            //   topLeft: Radius.circular(20),
            // ),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'To-do List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    // bottomLeft
                    offset: Offset(-1, -1),
                  ),
                  Shadow(
                    // bottomRight
                    offset: Offset(1, -1),
                  ),
                  Shadow(
                    // topRight
                    offset: Offset(1, 1),
                  ),
                  Shadow(
                    // topLeft
                    offset: Offset(-1, 1),
                  ),
                ],
              ),
            ),
            // Text(
            //   '${TEntryProvider().showTotalTasks()} Tasks',
            //   //'Tasks',
            //   style: TextStyle(
            //     color: Theme.of(context).primaryColor,
            //     fontSize: 12,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
