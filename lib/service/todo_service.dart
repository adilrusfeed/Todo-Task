import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todotask/model/todo_model.dart';

class TodoService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference<TodoModel> collectionReference;

  TodoService() {
    collectionReference =
        firebaseFirestore.collection('Notes').withConverter<TodoModel>(
      fromFirestore: (snapshot, options) {
        return TodoModel.fromJson(snapshot.id, snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  Future<void> addTodo(TodoModel note) async {
    try {
      final docRef = await collectionReference.add(note);
      note.id = docRef.id;
      note.notificationId = docRef.hashCode;
      // await scheduleNotification(note);
      log('Todo added');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTodo(String id, TodoModel note) async {
    try {
      await collectionReference.doc(id).update(note.toJson());
      // await scheduleNotification(note);
      log('Todo updated');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final doc = await collectionReference.doc(id).get();
      TodoModel? note = doc.data();
      if (note != null && note.notificationId != null) {
        // await flutterLocalNotificationsPlugin.cancel(note.notificationId!);
      }
      await collectionReference.doc(id).delete();
      log('Todo deleted');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TodoModel>> getAllTodo() async {
    try {
      final data = await collectionReference.get();
      return data.docs.map((e) => e.data()).toList();
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  // Future<void> scheduleNotification(TodoModel note) async {
  //   if (note.deadline != null) {
  //     tz.initializeTimeZones();
  //     final scheduledTime = tz.TZDateTime.from(
  //       note.deadline!.subtract(const Duration(minutes: 10)),
  //       tz.local,
  //     );

  //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //         AndroidNotificationDetails(
  // 'channel_id', // id
  // 'Task_Reminder', // title
  // channelDescription: 'ToDo', // description
  // importance: Importance.max,
  // priority: Priority.high,
  // showWhen: false,
  //     );

  //     const NotificationDetails platformChannelSpecifics =
  //         NotificationDetails(android: androidPlatformChannelSpecifics);

  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       note.notificationId!, // Use the unique notification ID
  //       'Task Reminder: ${note.title}',
  //       'Your task is due in 10 minutes.',
  //       scheduledTime,
  //       platformChannelSpecifics,
  //       androidScheduleMode:
  //           AndroidScheduleMode.exactAllowWhileIdle, // Use the new parameter
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //     );
  //   }
  // }
}
