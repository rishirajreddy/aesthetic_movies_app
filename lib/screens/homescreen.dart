//@dart = 2.9
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/provider/provider_google.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum Page { home_page, form_page }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Page currentPage = Page.home_page;
  bool isButtonDisabled = false;
  final List<String> movies = [];
  final List<String> directors = [];
  final List<File> images = [];
  String movie_input;
  String director_input;
  File imgFile;
  final imgPicker = ImagePicker();

  final user = FirebaseAuth.instance.currentUser;

  TextEditingController movie_controller = TextEditingController();
  TextEditingController director_controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    currentPage = Page.home_page;
    isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  direction: Axis.vertical,
                  children: [
                Text("Movies List"),
                Text("(Welcome ${user.displayName}!)",
                    style: TextStyle(fontSize: 10))
              ])),
          actions: [
            InkWell(
                onTap: () {
                  final provider =
                      Provider.of<GoogleSiginProvider>(context, listen: false);
                  provider.logout();
                },
                child: Icon(Icons.logout, color: Colors.white))
          ],
          leading: currentPage == Page.home_page
              ? null
              : InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = Page.home_page;
                    });
                  },
                  child: Icon(Icons.arrow_back)),
        ),
        body: currentPage == Page.home_page
            ? getHomePageWidget(context)
            : getFormWidget(context),
        bottomNavigationBar:
            isButtonDisabled == false ? getBottomButton() : null);
  }

  getHomePageWidget(context) {
    isButtonDisabled = false;
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                getUpdateDialog(index);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Colors.blueAccent,
              contentPadding: EdgeInsets.all(10),
              leading: Image.file(images[index]),
              title: Wrap(direction: Axis.vertical, children: [
                Text(
                  "Movie",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  movies[index],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              subtitle: Wrap(direction: Axis.vertical, children: [
                Text(
                  "Director: Name",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(directors[index],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ]),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      getDeleteDialog(index);
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ),
          );
        });
  }

  getFormWidget(context) {
    isButtonDisabled = true;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width - 120,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Add Movie Items",
              style: TextStyle(color: Colors.blueAccent),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: movie_controller,
              decoration: InputDecoration(
                  labelText: "Movie Name", prefixIcon: Icon(Icons.movie)),
            ),
            TextFormField(
              controller: director_controller,
              decoration: InputDecoration(
                  labelText: "Director Name", prefixIcon: Icon(Icons.camera)),
            ),
            SizedBox(
              height: 20,
            ),
            imgFile == null
                ? Container(child: Text("No Image Selected"))
                : displayImage(),
            FlatButton(
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: () {
                  showOptionsDialog(context);
                },
                child: Text("Add Image")),
            FlatButton(
                color: Colors.greenAccent,
                onPressed: () {
                  if (movie_controller == null ||
                      imgFile == null ||
                      director_controller == null) {
                    setState(() {
                      currentPage = Page.form_page;
                    });
                  } else {
                    setState(() {
                      movies.add(movie_controller.text);
                      directors.add(director_controller.text);
                      images.add(imgFile);
                      movie_controller.clear();
                      director_controller.clear();
                      imgFile = null;
                      currentPage = Page.home_page;
                    });
                  }
                },
                child: Text("Add"))
          ]),
        ),
      ),
    );
  }

  getBottomButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isButtonDisabled = true;
          currentPage = Page.form_page;
        });
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 750,
        child: BottomAppBar(
          color: Colors.blue,
          child: Center(
              child: Text(
            "Add Movie",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  void getDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(movies[index]),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  textColor: Colors.red,
                  onPressed: () {
                    setState(() {
                      movies.removeAt(index);
                      directors.removeAt(index);
                      images.removeAt(index);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  void getUpdateDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: new AlertDialog(
              title: Stack(children: [
                Text("Edit"),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Icon(Icons.edit),
                ),
                Align(
                  alignment: Alignment(1.05, -1.05),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          // imgFile = null;
                        });
                      },
                      child: Icon(Icons.close, color: Colors.red)),
                ),
              ]),
              actions: [
                TextFormField(
                  onChanged: (value) {
                    movie_input = value;
                  },
                  decoration: InputDecoration(labelText: "Movie Name"),
                ),
                TextFormField(
                  onChanged: (value) {
                    director_input = value;
                  },
                  decoration: InputDecoration(labelText: "Director's Name"),
                ),
                imgFile == null ? Container() : displayImage(),
                Center(
                  child: FlatButton(
                      color: Colors.indigo,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          showOptionsDialog(context);
                        });
                      },
                      child: Text("Add Image")),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: FlatButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.greenAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          movies[index] = movie_input;
                          directors[index] = director_input;
                          images[index] = imgFile;
                          imgFile = null;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text("Done")),
                ),
              ],
            ),
          );
        });
  }

  openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery.path);
    });
    Navigator.of(context).pop();
  }

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera.path);
    });
    Navigator.of(context).pop();
  }

  Widget displayImage() {
    if (imgFile == null) {
      return Text("No Image Selected!");
    } else {
      return Image.file(imgFile, width: 200, height: 200);
    }
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Capture Image From Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Take Image From Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
