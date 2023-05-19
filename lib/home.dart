import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class Todo {
  String title;
  bool isDone;
  Todo({
    required this.title,
    required this.isDone,
  });
}

class _MyAppState extends State<MyApp> {

  int currentTab = 0;
  List<Todo> todos = [
    Todo(
      title: "Buy Milk",
      isDone: false,
    ),
    Todo(
      title: "Buy Eggs",
      isDone: false,
    ),
    Todo(
      title: "Buy Bread",
      isDone: false,
    ),
  ];


  Widget renderList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(todos[index].title),
          trailing: Checkbox(
            value: todos[index].isDone,
            onChanged: (bool? value) {
              setState(() {
                todos[index].isDone = value!;
              });
            },
          ),
        );
      },
    );
  }

  //create a function to return a widget
  Widget getBody(int tabIndex,BuildContext context) {
    int selectedTodo = -1;
    // Introduce MaterialLocalizations for the dialog
    switch (tabIndex) {
      case 0:
        return Column(
            children: [
              Expanded(child: renderList()),
              FloatingActionButton(onPressed: () {
                Todo newTodo = Todo(
                  title: "",
                  isDone: false,
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Add Todo"),
                        content: TextField(
                          onChanged: (String value) {
                            newTodo.title = value;
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  todos.add(newTodo);
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Add"))
                        ],
                      );
                    });
              },child: const Icon(Icons.add))

            ]);
      case 1:
        return const SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Text("Settings "),
          ),
        );
      case 2:
        return const SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Text("Profile "),
          ),
        );
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Simple Todo App")),
      ),
      body: getBody(currentTab,context),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
              tooltip: "Settings"),
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
