class UserModel {
  String? uid;
  String? username;
  String? email;
  String? photoUrl;

  UserModel({this.uid, this.username, this.email, this.photoUrl});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    username = map["username"];
    email = map["email"];
    photoUrl = map["photoUrl"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "photoUrl": photoUrl,
    };
  }
}