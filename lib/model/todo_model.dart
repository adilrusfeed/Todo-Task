import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? title;
  String? detail;
  String? id;
  DateTime? deadline;
  Duration? expectedDuration;
  bool isCompleted;
  int? notificationId;
  TodoModel(
      {this.title,
      this.detail,
      this.id,
      this.deadline,
      this.expectedDuration,
      this.isCompleted = false,
      this.notificationId});

  factory TodoModel.fromJson(String id, Map<String, dynamic> json) {
    return TodoModel(
        title: json['title'] as String?,
        detail: json["detail"] as String,
        id: id,
        deadline: (json['deadline'] as Timestamp?)?.toDate(),
        expectedDuration: json['expectedDuration'] != null
            ? Duration(minutes: json['expectedDuration'])
            : null,
        isCompleted: json['isCompleted'] ?? false,
        notificationId: json['notificationId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'deadline': deadline,
      'expectedDuration': expectedDuration?.inMinutes,
      'isCompleted': isCompleted,
      'notificationId': notificationId
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? detail,
    DateTime? deadline,
    Duration? expectedDuration,
    bool? isCompleted,
    int? notificationId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      expectedDuration: expectedDuration ?? this.expectedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationId: notificationId ?? this.notificationId,
      detail: detail ?? this.detail,
    );
  }
}
