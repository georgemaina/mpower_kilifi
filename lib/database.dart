import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'models/counties.dart';
// import 'package:flutter/foundation.dart';
import 'package:mpower_achap/screens/globals.dart' as globals;
import 'package:mpower_achap/models/defaulters.dart';

class DBProvider {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("CREATE TABLE defaulters ("
        "ID                   INTEGER PRIMARY KEY AUTOINCREMENT,"
        "names                TEXT,"
        "dob                  TEXT,"
        "sex                  TEXT,"
        "serviceDefaulted     TEXT,"
        "village              TEXT,"
        "guardian             TEXT,"
        "contacts             TEXT,"
        "chvName              TEXT,"
        "dateRegistered       TEXT,"
        "contacted            TEXT,"
        "reasonNotContacted   TEXT,"
        "isDefaulter          TEXT,"
        "serviceLocation      TEXT,"
        "serviceDate          TEXT,"
        "referTo              TEXT,"
        "dateContacted        TEXT,"
        "mohSerialNo          TEXT,"
        "inputdate            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"
        ")");

    await database.execute("CREATE TABLE household_mapping ("
        "ID               INTEGER PRIMARY KEY AUTOINCREMENT,"
        "dateContacted    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        "mothersName      TEXT,"
        "chuName          TEXT,"
        "hhNo             TEXT,"
        "yearBirth        TEXT,"
        "delivered        TEXT,"
        "dateDelivered    TEXT,"
        "deliveryPlace    TEXT,"
        "sex              TEXT,"
        "weightAtBirth    TEXT,"
        "supportGroup     TEXT,"
        "married          TEXT,"
        "spouseName       TEXT,"
        "spouseContact    TEXT,"
        "otherName        TEXT,"
        "otherContact     TEXT,"
        "inputdate        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"
        ")");


    await database.execute("CREATE TABLE health_workers ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "names             TEXT,"
        "phone             TEXT,"
        "facility          TEXT,"
        "county            TEXT,"
        "subcounty         TEXT,"
        "mflcode           TEXT,"
        "venue             TEXT,"
        "gathering         TEXT,"
        "menreached        TEXT,"
        "womenreached      TEXT,"
        "disabledreached   TEXT,"
        "inputdate         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"
        ")");

    await database.execute("CREATE TABLE counties ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "countycode         TEXT,"
        "county             TEXT"
        ")");

    await database.execute("CREATE TABLE sub_counties ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "countycode         TEXT,"
        "county             TEXT,"
        "sub_county          TEXT"
        ")");

    await database.execute("CREATE TABLE facilities ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "facilityname         TEXT,"
        "mflcode             TEXT,"
        "showinrefer         TEXT"
        ")");

    await database.execute("CREATE TABLE chus ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "chuNames         TEXT,"
        "ward             TEXT,"
        "linkFacility         TEXT"
        ")");

    await database.execute("CREATE TABLE users ("
        "id                INTEGER PRIMARY KEY AUTOINCREMENT,"
        "username         TEXT,"
        "password         TEXT,"
        "usergroup        TEXT,"
        "names            TEXT,"
        "phone            TEXT,"
        "email            TEXT,"
        "designation      TEXT,"
        "facility        TEXT"
        ")");

    await database.execute("CREATE TABLE userlogs("
        "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "username TEXT,"
        "names TEXT,"
        "facility TEXT,"
        "logtime TEXT,"
        "logstatus TEXT,"
        "longtude TEXT,"
        "latitude TEXT"
        ")");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mpower_achap.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //Show all tables
  static Future<List<Map<String, dynamic>>> showTables() async {
    final db = await DBProvider.db();
    var results = (await db.query('sqlite_master', columns: ['type', 'name']))
        .forEach((row) {
      print(row.values);
    });
    // print(results);
    // return results;
    return db.query('health_workers', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUser(String username) async {
    final db = await DBProvider.db();
    return db.query('users',
        where: "username = ?", whereArgs: [username], limit: 1);
  }

  // Read all items (workers)
  static Future<List<Map<String, dynamic>>> countRecords() async {
    final db = await DBProvider.db();
    return await db.query('defaulters', orderBy: "id");
  }

  static Future<int> enrollDefaulter(
      String names,String dob, String sex,String serviceDefaulted,String village,String guardian,String contacts,
      String chvName,String dateRegistered,String contacted,String reasonNotContacted,String isDefaulter,String serviceLocation,
      String serviceDate,String referTo,String dateContacted) async {
    final db = await DBProvider.db();

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-mm-dd H:m:s');
    final String dateregistered = formatter.format(now);

    final data = {"names": names,"dob": dob,"sex": sex,"serviceDefaulted": serviceDefaulted,"village": village,
      "guardian": guardian,"contacts": contacts,"chvName": chvName,"dateRegistered": dateregistered};

    print(data.toString());

    final id = await db.insert('defaulters', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    globals.clientID = id.toString();

    print("Client ID=${id.toString()}");
    return id;
  }

  static Future<int> enrollHouseholds(
      String mothersName,String chuName,String hhNo, String yearBirth, String delivered,String dateDelivered,
      String deliveryPlace,String sex,String weightAtBirth,String supportGroup,String married,String spouseName,
      String spouseContact,String otherName,String otherContact) async {
    final db = await DBProvider.db();

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-mm-dd H:m:s');
    final String dateregistered = formatter.format(now);

    final data = {"mothersName": mothersName, "chuName": chuName,"hhNo": hhNo,"yearBirth": yearBirth,"delivered": delivered,
      "dateDelivered": dateDelivered,"deliveryPlace": deliveryPlace,"sex": sex, "weightAtBirth": weightAtBirth,
      "supportGroup": supportGroup,"married": married,"spouseName": spouseName, "spouseContact": spouseContact,
      "otherName": otherName,"otherContact": otherContact};

    print(data.toString());

    final id = await db.insert('household_mapping', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    globals.clientID = id.toString();

    print("Client ID=${id.toString()}");
    return id;
  }


  // Read all items (workers)
  // static Future<List<Client>> getDefaulters() async {
  //   final db = await DBProvider.db();
  //   final List<Map<String, dynamic>> maps= await db.query('defaulters', orderBy: "id");
  //
  //   return List.generate(maps.length, (i) {
  //     return Client(ID: maps[i]['ID'], names: maps[i]['names'], dob: maps[i]['dob'], sex: maps[i]['sex'],
  //         serviceDefaulted: maps[i]['serviceDefaulted'],
  //         village: maps[i]['village'], guardian: maps[i]['guardian'], contacts: maps[i]['contacts'], chvName: maps[i]['chvName'],
  //         dateRegistered: maps[i]['dateRegistered'], contacted: maps[i]['contacted'], reasonNotContacted: maps[i]['reasonNotContacted'],
  //         isDefaulter: maps[i]['isDefaulter'], serviceLocation: maps[i]['serviceLocation'], serviceDate: maps[i]['serviceDate'],
  //         referTo: maps[i]['referTo'], dateContacted: maps[i]['dateContacted']);
  //   });
  //
  // }

  static Future<List<Map<String, dynamic>>> getDefaulters() async {
    final db = await DBProvider.db();
    var maps = await db.query('defaulters', orderBy: "ID");
    // print(maps);

    //if(maps.isNotEmpty){
    return maps;
    // }
  }

  static Future<List<Map<String, dynamic>>> getHouseHoldMapping() async {
    final db = await DBProvider.db();
    var maps = await db.query('household_mapping', orderBy: "ID");
    // print(maps);

    //if(maps.isNotEmpty){
    return maps;
    // }
  }


  // Read all items (workers)
  static Future<List<Map<String, dynamic>>> getWorkers() async {
    final db = await DBProvider.db();
    return db.query('health_workers', orderBy: "id");
  }

  // Read all items (Counties)
  static Future<List<Map<String, dynamic>>> getSubCounties() async {
    final db = await DBProvider.db();
    return db.query('sub_counties', orderBy: "id");
  }

  static Future uploadCounties() async {
    final db = await DBProvider.db();
    sql.Batch batch = db.batch();
    String countiesJson =
        await rootBundle.loadString('assets/subcounties.json');
    List countiesList = json.decode(countiesJson);

    countiesList.forEach((element) {
      SubCounties county = SubCounties.fromMap(element);
      batch.insert('sub_counties', county.MaptoSubCountiesListMap());
    });
    final id = await batch.commit();
    return id;
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getWorker(int id) async {
    final db = await DBProvider.db();
    return db.query('health_workers',
        where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Fetch Operation: Get all
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    final db = await DBProvider.db();
    //		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query("diabetes", orderBy: 'ID ASC');
    return result;
  }

  // Insert Operation: Insert a diabetes awareness to database

  static Future<int> deleteRows() async {
    final db = await DBProvider.db();

    // db.execute("Delete from enrollments");
    // db.execute("Delete from diabetes");
    // db.execute("Delete from hypertension");
    // db.execute("Delete from anaemia");
    // db.execute("Delete from epilepsy");
    // db.execute("Delete from cancer");
    // db.execute("Delete from health_workers");

    return 1;
  }
}
