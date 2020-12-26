import 'package:cempro_gps/modelos/login_class.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "Nueva.db";
  static final _databaseVersion = 1;

  static final table = 'logs_table';

  static final columnId = 'id';
  static final columnName = 'log_name';
  static final nombre = 'nombre';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName INTEGER NOT NULL,
            $nombre TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Login car) async {
    Database db = await instance.database;
    return await db.insert(table, {'log_name': car.log_name, 'nombre': car.nombre});
  }


  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$nombre LIKE '%$name%'");
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> getVeces(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName > '$name'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Login log) async {
    Database db = await instance.database;
    int id = log.toMap()['id'];
    return await db.update(table, log.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }


  Future<List<Login>> getUser(int email) async {
    var dbClient = await _database;
    List<Login> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM logs_table WHERE log_name=\'$email\'',
    );
    print('[DBHelper] Veces: ${queryList.length} users');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(Login(
        queryList[i]['id'],
        queryList[i]['log_name'],
        queryList[i]['nombre'],
      ));
    }
    print('[DBHelper] getUser: ${usersList[0].nombre}');
      return usersList;
    } else {
    print('[DBHelper] getUser: User is null');
      return null;
    }
  }
}


