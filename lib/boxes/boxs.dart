import 'package:hive/hive.dart';
import 'package:movie/modal/moviedb.dart';

class Boxes{
  static Box<MovieDb> getMovieDb() => Hive.box<MovieDb>('moviedb');

}