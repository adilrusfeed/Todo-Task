import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todotask/controller/todo_provider.dart';
import 'package:todotask/model/todo_model.dart';
import 'package:todotask/view/taskbuild_screen.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskItemScreen extends StatelessWidget {
  final TodoModel task;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TaskItemScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoController>(context, listen: false);
    final DateTime notificationDateTime =
        task.deadline!.subtract(Duration(minutes: 10));
    _scheduleNotification(notificationDateTime, task.title!);
    return ListTile(
      title: Text(task.title!),
      subtitle: Text(task.detail!),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (value) async {
          final updatedTask = task.copyWith(isCompleted: value);
          await todoProvider.editTodo(task.id!, updatedTask);
        },
      ),
      onTap: () async {
        final updatedTask = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskFormScreen(task: task),
          ),
        );
        if (updatedTask != null && updatedTask is TodoModel) {
          await todoProvider.editTodo(task.id!, updatedTask);
        }
      },
      onLongPress: () {
        _showDeleteConfirmationDialog(context);
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final todoProvider = Provider.of<TodoController>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await todoProvider.deleteTodo(task.id!);
                // _cancelNotification(task.id!);
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _scheduleNotification(DateTime dateTime, String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifies =
        AndroidNotificationDetails(
      'channel_id', // id
      'Task_Reminder', // title
      channelDescription: 'ToDo', // description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifies =
        NotificationDetails(android: androidPlatformChannelSpecifies);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.hashCode,
      "Task Deadline Approaching",
      'The Deadline for "$title" is getting near,Hurry up!',
      tz.TZDateTime.from(dateTime, tz.local),
      platformChannelSpecifies,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // void _cancelNotification(String taskId) async {
  //   await flutterLocalNotificationsPlugin.cancel(taskId.hashCode);
  // }
}
