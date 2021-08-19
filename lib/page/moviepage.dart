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
          title: Text('Hive Expense Tracker'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<MovieDb>>(
          valueListenable: Boxes.getMovieDb().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<MovieDb>();

            return buildContent(transactions);
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

  Widget buildContent(List<MovieDb> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet!',
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
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

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
    MovieDb transaction,
  ) {
    print(transaction.img);
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        leading: Image.memory(transaction.img),
        subtitle: Text(transaction.des),
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          transaction.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, MovieDb transaction) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDialog(
                    moviedb: transaction,
                    onClickedDone: (name, des, file) =>
                        editTransaction(transaction, name, des, file),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(transaction),
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
      MovieDb transaction, String name, String des, Uint8List file) {
    transaction.name = name;
    transaction.des = des;
    transaction.img = file;
    transaction.save();
  }

  void deleteTransaction(MovieDb transaction) {
    transaction.delete();
  }
}
