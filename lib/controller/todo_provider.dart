import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todotask/model/todo_model.dart';
import 'package:todotask/service/auth_service.dart';
import 'package:todotask/service/todo_service.dart';

class TodoController extends ChangeNotifier {
  final TodoService _notesService = TodoService();
  List<TodoModel> _todo = [];
  List<TodoModel> get todo => _todo;
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final todo = await _notesService.getAllTodo();
      return todo;
    } catch (e) {
      log("Error getting all todo:$e");
      return [];
    }
  }

  Future<void> addTodo(TodoModel note) async {
    try {
      await _notesService.addTodo(note);
      notifyListeners();
    } catch (e) {
      log('Error adding todo:$e');
    }
  }

  Future<void> editTodo(String id, TodoModel note) async {
    try {
      await _notesService.editTodo(id, note);
      notifyListeners();
    } catch (e) {
      log("Error editing todo:$e");
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _notesService.deleteTodo(id);
      notifyListeners();
    } catch (e) {
      log("Error deleting todo:$e");
    }
  }

  void logOut() {
    try {
      AuthService().signOut();
      notifyListeners();
    } catch (e) {
      log("Error logging out:$e");
    }
  }
}
