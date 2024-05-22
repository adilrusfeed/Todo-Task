class UserModel {
  String? userName;
  String? email;
  String? password;

  UserModel({this.userName, this.email, this.password});

  factory UserModel.fromJson(json) {
    return UserModel(
      userName: json["userName"],
      email: json["email"],
    );
  }
  Map<String, dynamic> toJson() {
    return {"userName": userName, 'email': email};
  }
}
