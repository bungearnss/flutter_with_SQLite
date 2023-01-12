import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  final String tableName = 'products';
  final String idColumn = 'id';
  final String nameColumn = 'product';
  final String imageColumn = 'image';
  final String descriptionColumn = 'description';

  static Database? _db;
  static DBHelper? _currentInstance;

  DBHelper._internal();

  factory DBHelper() {
    return _currentInstance ?? DBHelper._internal();
  }

  Future<void> initDB() async {
    if (_db == null) {
      print("DB initialized");

      var directory = await getApplicationDocumentsDirectory();
      var path = join(directory.path, 'products.db');

      _db = await openDatabase(path, version: 1, onCreate: _createDatabase);
      _populateProducts();
    }
  }

  Future<void> _createDatabase(Database database, int version) async {
    print("Create database called");

    String createQuery = "CREATE TABLE $tableName"
        "($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"
        "$imageColumn TEXT, $descriptionColumn TEXT);";

    print(createQuery);

    await database.execute(createQuery);
  }

  Future<void> _populateProducts() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool('products_populated') ?? false) {
      return;
    }
    print("Populate products called");

    var productsList = [
      {'product': 'Car', 'image': 'car.png', 'description': 'A speedy car'},
      {'product': 'Doll', 'image': 'doll.png', 'description': 'A cute doll'},
      {'product': 'Robot', 'image': 'robot.png', 'description': 'A fun robot'},
    ];

    for (var productMap in productsList) {
      await _db?.insert(tableName, productMap);
    }

    await sharedPreferences.setBool('products_populated', true);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    await initDB();

    return await _db?.query(tableName) ?? [];
  }

  Future<int?> addData(Map<String, dynamic> productMap) async {
    await initDB();

    return await _db?.insert(tableName, productMap);
  }
}
