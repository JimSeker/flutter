import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HighScore {
  int id;
  String name;
  int score;

  HighScore({
    required this.id,
    required this.name,
    required this.score,
  });

  // Convert a HighScore into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
    };
  }

  Map<String, dynamic> toMapNoID() {
    return {
      'name': name,
      'score': score,
    };
  }

  // Implement toString to make it easier to see information,
  //  when using the print statement.
  @override
  String toString() {
    return 'id: $id, name: $name, age: $score';
  }
}

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'highscore_table';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnScore = 'score';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnScore INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(HighScore score) async {
    return await _db.insert(
      table,
      score.toMapNoID(), //since id is autoincrmented, we don't provide it.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.  we are return the data structure, but you could
  //just return the maps if you wanted.
  Future<List<HighScore>> queryAllRows() async {
    final List<Map<String, dynamic>> maps = await _db.query(table);

    print('query all rows:');
    for (final row in maps) {
      print(row.toString());
    }

// Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return HighScore(
        id: maps[i][columnId] ?? 0,
        //should not be needed, but null will cause it to crash, so provided a default value.
        name: maps[i][columnName],
        score: maps[i][columnScore] ?? -1,
      );
    });
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(HighScore row) async {
    int id = row.id;
    return await _db.update(
      table,
      row.toMap(),
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
