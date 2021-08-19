import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie/modal/moviedb.dart';

class MovieDialog extends StatefulWidget {
  final MovieDb moviedb;
  final Function(String name, String des, Uint8List img) onClickedDone;
  MovieDialog({Key key, this.moviedb, this.onClickedDone}) : super(key: key);

  @override
  _MovieDialogState createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final desController = TextEditingController();
  Uint8List img;
  File imgsrc;
  bool imgchange = false;
  @override
  void initState() {
    super.initState();

    if (widget.moviedb != null) {
      final moviedb = widget.moviedb;
      nameController.text = moviedb.name;
      desController.text = moviedb.des;
      img = moviedb.img;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.moviedb != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
              isEditing ? showimg() : pickImage()
            ],
          ),
        ),
      ),
      actions: [
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Description',
        ),
        keyboardType: TextInputType.number,
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a desc' : null,
        controller: desController,
      );
  showimg() {
    print(imgchange);
    return GestureDetector(
      child: Container(
        child: imgchange
            ? Image.memory(imgsrc.readAsBytesSync())
            : Image.memory(
                img,
              ),
      ),
      onTap: () async {
        File picker = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        setState(() {
          imgsrc = picker;
          imgchange = true;
        });
      },
    );
  }

  pickImage() {
    return GestureDetector(
      onTap: () async {
        File picker = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        setState(() {
          imgsrc = picker;
        });
      },
      child: Container(
        color: Colors.grey[100],
        height: 100,
        width: 100,
        child: imgsrc != null
            ? Container(child: Image.memory(imgsrc.readAsBytesSync()))
            : Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Pick Image",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {@required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          final name = nameController.text;
          final desc = desController.text;
          final img = imgsrc.readAsBytesSync();

          widget.onClickedDone(name, desc, img);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
