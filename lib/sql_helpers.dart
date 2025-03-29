import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class SqlHelper {
  static Database? database;

  static getDatabase() async {
    if (database == null) {
      database = await initdatabase();
      return database;
    } else {
      return database;
    }
  }

  // الفانكشن دي بتشتغل مره واحده بس في اول مره
  static initdatabase() async {
    String path = join(await getDatabasesPath(), 'notes.dp');
    return await openDatabase(path, version: 1, onCreate: (dp, index) async {
      Batch batch = dp.batch();
      batch.execute('''
         CREATE TABLE notes(
           id INTEGER PRIMARY KEY AUTOINCREMENT, 
           title TEXT,
           desc TEXT
         )
         ''');
      batch.commit();
    });
  }
  //  CRUD Operation //

  //CREATE
  Future addNote(Note newNote) async {
    Database db = await getDatabase();

    await db.insert(
      'notes',
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //READ
  Future<List<Map>> loadNotes() async {
    Database db = await getDatabase();
    return await db.query('notes');
  }

  //UPDATE
  Future updateNote(Note note) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    batch.commit();
  }

  //DELETE
  Future deleteNote(int id) async {
    Database db = await getDatabase();
    await db.delete(
        'notes',
        where: 'id=?',
        whereArgs: [id]
    );
  }

  Future deleteAllNotes() async {
    Database db = await getDatabase();
    await db.delete('notes');
  }
}
