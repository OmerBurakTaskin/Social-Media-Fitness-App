class User {
  String _name;
  String _surName;
  String _userName;
  String _email;
  String _uID;
  List<String> _friends = [];
  List<String> _chattingFriends = [];

  User(
      {required String userId,
      required String name,
      required String surName,
      required String userName,
      required String email})
      : _uID = userId,
        _name = name,
        _surName = surName,
        _userName = userName,
        _email = email;

  User.allAttributes(
      {required String userId,
      required String name,
      required String surName,
      required String userName,
      required String email,
      required List<String> friends,
      required List<String> chattingFriends})
      : _uID = userId,
        _name = name,
        _surName = surName,
        _userName = userName,
        _email = email,
        _friends = friends,
        _chattingFriends = chattingFriends;

  User.fromJson(Map<String, dynamic> json)
      : this.allAttributes(
            userId: json["userId"]! as String,
            name: json["name"]! as String,
            surName: json["surname"]! as String,
            userName: json["username"]! as String,
            email: json["email"]! as String,
            friends: List<String>.from(json["friends"] ?? []),
            chattingFriends: List<String>.from(json["chattingFriends"] ?? []));

  Map<String, dynamic> toJson() {
    return {
      "userId": _uID,
      "name": _name,
      "surname": _surName,
      "username": _userName,
      "email": _email
    };
  }

  String get name => _name;
  String get surName => _surName;
  String get userName => _userName;
  String get email => _email;
  String get userId => _uID;
  List<String> get friends => _friends;
  List<String> get chattingFriends => _chattingFriends;
}
