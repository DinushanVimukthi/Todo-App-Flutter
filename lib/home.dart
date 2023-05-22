import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/login.dart';
import 'package:todo/profile/profile.dart';
import 'package:todo/themeProvider.dart';
import 'package:todo/user.dart';

import 'Todo.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentTab = 0;
  List<Todo> todos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      Future.delayed(const Duration(seconds: 1),(){
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void setLoading(bool value){
    setState(() {
      isLoading = value;
    });
  }




  void popUpMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: color,
      elevation: 1000,
      content: Text(message),
    ));
  }

  Widget todoItem({required Todo todo, required BuildContext context}) {
    return Container(
        height: 180,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
            ]),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title ?? '',
                  maxLines: 1,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      height: 50,
                                      color: const Color.fromARGB(
                                          228, 113, 0, 112),
                                      child: const Text("Edit Todo",
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center)),
                                  content: SizedBox(
                                    height: 380,
                                    width: 400,
                                    child: Column(
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                            label: Text("Todo Title"),
                                              hintText: "Enter Todo Title"),
                                          controller: TextEditingController()
                                            ..text = todo.title ?? '',
                                          onChanged: (value) {
                                            todo.title = value;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          // Make the textfield multiline
                                          maxLines: 5,
                                          decoration: const InputDecoration(
                                              label: Text("Todo Description"),
                                              hintText:
                                                  "Enter Todo Description"),
                                          controller: TextEditingController()
                                            ..text = todo.description ?? '',
                                          onChanged: (value) {
                                            todo.description = value;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.green
                                                        .withOpacity(0.8)),
                                                onPressed: () {
                                                  if (todo.title == '') {
                                                    // Show a banner
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      elevation: 1000,
                                                      margin: EdgeInsets.only(
                                                          top: 72.0),
                                                      content: Text(
                                                          'Please enter a todo title'),
                                                    ));
                                                    Navigator.of(context).pop();
                                                    return;
                                                  }
                                                  Todo.updateTodo(todo);
                                                  popUpMessage(
                                                      context,
                                                      'Todo updated successfully',
                                                      Colors.green);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.0),
                                                    child: Row(
                                                      // add a vertical padding
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.update),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Update Todo",
                                                          style: TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ))),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.redAccent
                                                        .withOpacity(0.8)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.0),
                                                    child: Row(
                                                      // add a vertical padding
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.cancel),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ))),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        )),
                    IconButton(
                      onPressed: () {
                        // Delete the todo
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this todo?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("No")),
                                  TextButton(
                                      onPressed: () {
                                        // Delete the todo
                                        Todo.deleteTodo(todo);
                                        popUpMessage(
                                            context,
                                            'Todo deleted successfully',
                                            Colors.red);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Yes")),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    )
                  ],
                )
              ],
            ),
            Text(
              todo.description ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
            ),
            const Divider(
              thickness: 2,
            )
          ],
        ));
  }

  void addTodo(BuildContext context) {
    Todo todo = Todo.createEmptyTodo();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 50,
                color: const Color.fromARGB(228, 113, 0, 112),
                child: const Text("Add Todo",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center)),
            content: SizedBox(
              height: 380,
              width: 400,
              child: Column(
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(
                            label: Text("Todo Title"),
                            hintText: "Enter Todo Title"),
                    maxLines: 1,
                    maxLength: 30,
                    onChanged: (value) {
                      todo.title = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    // Make the textfield multiline
                    maxLines: 5,
                    decoration: const InputDecoration(
                        label: Text("Todo Description"),
                        hintText: "Enter Todo Description"),
                    onChanged: (value) {
                      todo.description = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent.withOpacity(0.8)),
                          onPressed: () {
                            setLoading(true);
                            if (todo.title?.trim() == '') {
                              // Show a banner
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                elevation: 1000,
                                margin: EdgeInsets.only(top: 72.0),
                                content: Text('Please enter a todo title'),
                              ));
                              Navigator.of(context).pop();
                              setLoading(false);
                              return;
                            }
                            Todo.addNewTodo(todo);
                            Future.delayed(const Duration(seconds: 1), () {
                              setLoading(false);
                            }
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              behavior: SnackBarBehavior.fixed,
                              backgroundColor: Colors.green,
                              elevation: 1000,
                              content: Text('Todo added successfully'),
                            ));
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                // add a vertical padding
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_task),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Add Todo",
                                    style: TextStyle(
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent.withOpacity(0.8)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                // add a vertical padding
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cancel),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Cancel",
                                    style: TextStyle(
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //create a function to return a widget
  Widget getBody(int tabIndex, BuildContext context) {
    int selectedTodo = -1;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    print(userProvider.userID);

    Query query = FirebaseDatabase.instance
        .ref()
        .child('todos')
        .child(userProvider.userID);
    // Introduce MaterialLocalizations for the dialog
    switch (tabIndex) {
      case 0:
        return SizedBox(
          height: double.infinity,
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: FirebaseAnimatedList(
                query: query,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Todo todo = Todo.fromSnapshot(snapshot);
                  return todoItem(todo: todo, context: context);
                },
                defaultChild: const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
            ],
          ),
        );
      case 1:
        return profilePage(context);
      default:
        return const SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Text("Unknown "),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final uid = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Simple Todo App"),
            IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                  // update the material app theme using the provider
                },
                icon: const Icon(Icons.dark_mode))
          ],
        ),
      ),
      body: Center(
          child:Stack(
            children: [
              getBody(currentTab, context),
              if(isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton.large(
          backgroundColor: const Color.fromARGB(228, 113, 0, 112),
          tooltip: 'Add Todo',
          onPressed: () {
            addTodo(context);
          },
          child: const SizedBox(
            child: Icon(
              Icons.add,
              size: 30,
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(228, 113, 0, 112),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile", tooltip: "Profile")
        ],
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            // Show Selected Tab
          });
        },
      ),
    );
  }
}
