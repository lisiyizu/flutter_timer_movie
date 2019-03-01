import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constant.dart';
import '../entities/user_entity.dart';
import 'logger.dart';

class DatabaseUtil {
  var logger = Logger('DatabaseUtil');

  DatabaseUtil._internal();

  static DatabaseUtil _instance;

  static DatabaseUtil get instance => DatabaseUtil();

  factory DatabaseUtil() {
    if (_instance == null) _instance = DatabaseUtil._internal();
    return _instance;
  }

  static Database _database;

  /// 使用单例 database，防止重复创建消耗内存
  Future<Database> get database async {
    if (_database == null) _database = await openDb();
    return _database;
  }

  Future<String> getDbPath() async {
    var dataPath = await getApplicationDocumentsDirectory();
    var path = join(dataPath.path, Constant.DATABASE_NAME);
    return path;
  }

  Future<Database> openDb() async {
    var path = await getDbPath();

    var database = await openDatabase(path, version: 2, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE ${Constant.USER_TABLE_NAME}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatar_path TEXT DEFAULT "",
        gender INTEGER DEFAULT 0,
        birthday TEXT
      )''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      logger.log('onUpgrade, lastVersion: $oldVersion, currentVersion: $newVersion');
    });
    return database;
  }

  Future<int> insertUserIntoDb(String username, String password, String avatarPath) async {
    var db = await database;
    var values = avatarPath.isNotEmpty ? [username, password, avatarPath] : [username, password];
    return db.rawInsert(
        'INSERT INTO ${Constant.USER_TABLE_NAME} '
        '(username, password${avatarPath.isNotEmpty ? ', avatar_path' : ''}) '
        'VALUES(?, ?${avatarPath.isNotEmpty ? ', ?' : ''})',
        values);
  }

  Future<bool> isUserExists(String username) async {
    var db = await database;
    var list = await db.rawQuery('SELECT id, username FROM ${Constant.USER_TABLE_NAME} WHERE username = ?', [username]);
    return list.length > 0;
  }

  Future<User> getUserByUsername(String username) async {
    var db = await database;
    var list = await db.rawQuery(
        'SELECT id, username, password, avatar_path, gender, birthday '
        'FROM ${Constant.USER_TABLE_NAME} WHERE username = ?',
        [username]);
    if (list.isNotEmpty)
      return User.fromDbMap(list[0]);
    else
      return null;
  }

  Future<User> getUserById(int id) async {
    var db = await database;
    var list = await db.rawQuery(
        'SELECT id, username, password, avatar_path, gender, birthday '
        'FROM ${Constant.USER_TABLE_NAME} WHERE id = ?',
        [id]);
    if (list.isNotEmpty)
      return User.fromDbMap(list[0]);
    else
      return null;
  }

  Future<int> isUserValidate(String username, String password) async {
    var db = await database;
    var list = await db.rawQuery(
        'SELECT id FROM ${Constant.USER_TABLE_NAME} WHERE username = ? and password = ?', [username, password]);
    if (list.length > 0)
      return list[0]['id'];
    else
      return -1;
  }

  Future<int> updateUsername(int id, String newUsername) async {
    var db = await database;
    return db.rawUpdate('UPDATE ${Constant.USER_TABLE_NAME} SET username = ? WHERE id = ?', [newUsername, id]);
  }

  Future<int> updatePassword(int id, String password) async {
    var db = await database;
    return db.rawUpdate('UPDATE ${Constant.USER_TABLE_NAME} SET password = ? WHERE id = ?', [password, id]);
  }

  Future<int> updateAvatar(int id, String avatarPath) async {
    var db = await database;
    return db.rawUpdate('UPDATE ${Constant.USER_TABLE_NAME} SET avatar_path = ? WHERE id = ?', [avatarPath, id]);
  }

  Future<int> updateBirthday(int id, String birthday) async {
    var db = await database;
    return db.rawUpdate('UPDATE ${Constant.USER_TABLE_NAME} SET birthday = ? WHERE id = ?', [birthday, id]);
  }

  Future<int> updateGender(int id, int gender) async {
    var db = await database;
    return db.rawUpdate('UPDATE ${Constant.USER_TABLE_NAME} SET gender = ? WHERE id = ?', [gender, id]);
  }

  Future<int> deleteUser(int id) async {
    var db = await database;
    return db.rawDelete('DELETE FROM ${Constant.USER_TABLE_NAME} WHERE id = ?', [id]);
  }

  void allUser() async {
    var db = await database;
    var result = await db.rawQuery('SELECT * FROM ${Constant.USER_TABLE_NAME}');
    logger.log(result);
  }
}
