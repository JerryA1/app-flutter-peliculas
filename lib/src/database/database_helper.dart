import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/userDao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final _nombreBD = "PATM2020";
  static final _versionBD = 1;

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaDB = join(carpeta.path, _nombreBD);
    return await openDatabase(
      rutaDB,
      version: _versionBD,
      onCreate: _crearTablas
    );
  }

  _crearTablas(Database db, int version) async{
    await db.execute("CREATE TABLE tbl_perfil(id INTEGER PRIMARY, nomUser varchar(25), apepUser varchar(25), apemUser varchar(25), telUser char(10), emailUser varchar(30), foto varchar(255), username varchar(30), pwduser varchar(30))");

  }

  Future<int> insertar(Map<String, dynamic> row, String tabla) async{
    var dbClient = await database;
    return await dbClient.insert(tabla, row);
  }

  Future<int> actualizar(Map<String, dynamic> row, String tabla) async{
    var dbClient = await database;
    return await dbClient.update(tabla, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> eliminar(int id, String tabla) async{
    var dbClient = await database;
    return await dbClient.delete(tabla, where: 'id = ?', whereArgs: [id]);
  }

  Future<UserDAO> getUsuario(String email) async{
    var dbClient = await database;
    var result = await dbClient.query('tbl_perfil', where: 'emailUser = ?', whereArgs: [email]);
    var lista = (result).map((item) => UserDAO.fromJSON(item)).toList();
    return lista[0];
  }
}