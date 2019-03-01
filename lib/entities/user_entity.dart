class User {
  int id;
  String username;
  String password;
  String avatarPath;
  int gender;
  String birthday;

  User.defaultConstruct();

  User(this.id, this.username, this.password, this.avatarPath, this.gender, this.birthday);

  User.fromDbMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.username = map['username'],
        this.password = map['password'],
        this.avatarPath = map['avatar_path'],
        this.gender = map['gender'],
        this.birthday = map['birthday'];

  static User fromMap(Map<String, dynamic> map) {
    User temp = User.defaultConstruct();
    temp.id = map['id'];
    temp.username = map['username'];
    temp.password = map['password'];
    temp.avatarPath = map['avatar_path'];
    temp.gender = map['gender'];
    temp.birthday = map['birthday'];
    return temp;
  }

  static List<User> fromMapList(dynamic mapList) {
    List<User> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, avatarPath: $avatarPath, gender: $gender, birthday: $birthday}';
  }
}
