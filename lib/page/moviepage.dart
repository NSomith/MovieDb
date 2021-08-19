import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie/boxes/boxs.dart';
import 'package:movie/modal/moviedb.dart';
import 'package:movie/widget/Moviedialog.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<MovieDb>>(
          valueListenable: Boxes.getMovieDb().listenable(),
          builder: (context, box, _) {
            final movieslist = box.values.toList().cast<MovieDb>();

            return buildContent(movieslist);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MovieDialog(
              onClickedDone: (name, des, img) => addTransaction(name, des, img),
            ),
          ),
        ),
      );

  Widget buildContent(List<MovieDb> movieslist) {
    if (movieslist.isEmpty) {
      return Center(
        child: Text(
          'No saved movies yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movieslist.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = movieslist[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    MovieDb moviedb,
  ) {
    print(moviedb.img);
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        leading: Image.memory(moviedb.img),
        subtitle: Text(moviedb.des),
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          moviedb.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          buildButtons(context, moviedb),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, MovieDb moviedb) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDialog(
                    moviedb: moviedb,
                    onClickedDone: (name, des, file) =>
                        editTransaction(moviedb, name, des, file),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(moviedb),
            ),
          )
        ],
      );

  void addTransaction(String name, String desc, Uint8List imgfile) async {
    final transaction = MovieDb()
      ..name = name
      ..des = desc
      ..img = imgfile;

    final box = Boxes.getMovieDb();
    box.add(transaction);
  }

  void editTransaction(
      MovieDb moviedb, String name, String des, Uint8List imgbyte) {
    moviedb.name = name;
    moviedb.des = des;
    moviedb.img = imgbyte;
    moviedb.save();
  }

  void deleteTransaction(MovieDb transaction) {
    transaction.delete();
  }
}
