import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todotask/controller/todo_provider.dart';
import 'package:todotask/model/todo_model.dart';
import 'package:todotask/view/taskbuild_screen.dart';
import 'package:todotask/widgets/task_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoController>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("ToDo Task"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
          bottom: TabBar(tabs: const [
            Tab(
              text: "Pending Tasks",
            ),
            Tab(
              text: "Completed Tasks",
            ),
          ]),
        ),
        body: FutureBuilder<List<TodoModel>>(
          future: todoProvider.getAllTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Lottie.asset("assets/loading lottie.json"));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading Tasks"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No Tasks Found"));
            }
            final tasks = snapshot.data!;
            final pendingTasks =
                tasks.where((task) => !task.isCompleted).toList();
            final completedTasks =
                tasks.where((task) => task.isCompleted).toList();
            return TabBarView(
              children: [
                ListView.builder(
                    itemCount: pendingTasks.length,
                    itemBuilder: (context, index) {
                      final task = pendingTasks[index];
                      return TaskItemScreen(task: task);
                    }),
                ListView.builder(
                    itemCount: completedTasks.length,
                    itemBuilder: (context, index) {
                      final task = completedTasks[index];
                      return TaskItemScreen(task: task);
                    }),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(),
                ));
            if (result != null && result is TodoModel) {
              await todoProvider.addTodo(result);
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final todoProvider = Provider.of<TodoController>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                todoProvider.logOut();
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}
