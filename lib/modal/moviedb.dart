import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'moviedb.g.dart';

@HiveType(typeId: 0)
class MovieDb extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  String des;

  @HiveField(2)
  Uint8List img;
}
