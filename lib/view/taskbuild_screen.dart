import 'package:flutter/material.dart';

import 'package:todotask/model/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:todotask/widgets/duration_picker.dart';

class TaskFormScreen extends StatefulWidget {
  final TodoModel? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String detail;
  DateTime? deadline;
  late Duration expectedDuration;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title!;
      detail = widget.task!.detail!;
      deadline = widget.task!.deadline;
      expectedDuration = widget.task!.expectedDuration ?? Duration(hours: 1);
    } else {
      title = '';
      detail = '';
      expectedDuration = Duration(hours: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: detail,
                decoration: InputDecoration(labelText: 'Detail'),
                onSaved: (value) => detail = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a detail';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Deadline'),
                subtitle: Text(deadline == null
                    ? 'No date chosen'
                    : DateFormat.yMd().add_jm().format(deadline!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: deadline ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(deadline ?? DateTime.now()),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        deadline = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
              ListTile(
                  title: Text('Expected Duration'),
                  subtitle: Text(
                      '${expectedDuration.inHours} hours ${expectedDuration.inMinutes % 60} minutes'),
                  trailing: Icon(Icons.timer),
                  onTap: () async {
                    final pickededDuration =
                        await showModalBottomSheet<Duration>(
                            context: context,
                            builder: (context) => CustomDurationPicker(
                                initialDuration: expectedDuration,
                                onChanged: (value) {
                                  setState(() {
                                    expectedDuration = value;
                                  });
                                }));
                    if (pickededDuration != null) {
                      setState(() {
                        expectedDuration = pickededDuration;
                      });
                    }
                  }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newTask = TodoModel(
                      title: title,
                      detail: detail,
                      deadline: deadline,
                      expectedDuration: expectedDuration,
                      isCompleted: widget.task?.isCompleted ?? false,
                      id: widget.task?.id,
                    );
                    Navigator.pop(context, newTask);
                  }
                },
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
