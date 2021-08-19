import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie/modal/moviedb.dart';
import 'package:movie/page/moviepage.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(MovieDbAdapter());
  await Hive.openBox<MovieDb>('moviedb');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MoviePage(),
      ),
    );
  }
}
