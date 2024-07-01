import 'dart:developer';
import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> _getDataBase() async {
  // sqfliteFfiInit();
  // databaseFactoryOrNull = databaseFactoryFfi;
  // final dbPath = await sql.getDatabasesPath();
  // final db = await sql.openDatabase(
  //   path.join(dbPath, 'places.db'),
  //   onCreate: (db, version) {
  //     return db.execute(
  //         'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  //   },
  //   version: 1,
  // );
  // return db;

  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  Database database = await databaseFactory.openDatabase(
    join("D:/coding/database", 'places.db'),
    options: OpenDatabaseOptions(
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE user_places (
              id TEXT PRIMARY KEY, 
              name TEXT, 
              image TEXT, 
              lat REAL, 
              lng REAL, 
              address TEXT)''');
      },
      version: 1,
    ),
  );
  return database;

  // print(inMemoryDatabasePath);
  // sqfliteFfiInit();
  // final databaseFactory = databaseFactoryFfi;
  // final dbTest = await databaseFactory.openDatabase(
  //     join("D:/coding/database", 'places.db'),
  //     options: sql.OpenDatabaseOptions(
  //       version: 1,
  //       onCreate: (dbTemp, version) async {
  //         return dbTemp.execute(
  //             'CREATE TABLE user_places (id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  //       },
  //     ));

  // return dbTest;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    log("LOADING.....");
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['name'] as String,
            image: row['image'] == null ? row['image'] as Null : File(row['image'] as String),
            location: row['address'] == null
                ? row['address'] as Null
                : PlaceLocation(
                    latitude: row['lat'] as double,
                    longitude: row['lng'] as double,
                    address: row['address'] as String,
                  ),
          ),
        )
        .toList();
    log("$places");
    state = places;
  }

  void addNewPlace(Place place) async {
    if (!kIsWeb) {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      if (place.image != null) {
        final imageFileName =
            path.basename(place.image!.path); //place.image!.path.split("\\");
        final imageDir = join(appDir.path, imageFileName);
        final copiedImage = await place.image!.copy(imageDir);
        place = Place(
          name: place.name,
          image: copiedImage,
          imageWeb: place.imageWeb,
          location: place.location,
        );
      }
      final db = await _getDataBase();
      db.insert(
        "user_places",
        {
          'id': place.id,
          'name': place.name,
          'image': place.image?.path,
          'lat': place.location?.latitude,
          'lng': place.location?.longitude,
          'address': place.location?.address,
        },
      );
    }
    state = [place, ...state];
  }

  void removePlace(Place place) {
    state.removeWhere(
      (element) => element.id == place.id,
    );
  }

  void updatePlace(Place place, Place newPlace) {
    removePlace(place);
    addNewPlace(newPlace);
  }

  Place searchPlaceInList(Place place) {
    return state.firstWhere((e) => e == place);
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
