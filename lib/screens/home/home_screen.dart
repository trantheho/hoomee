import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoomee/model/piece.dart';
import 'package:hoomee/model/puzzple_piece.dart';
import 'package:hoomee/screens/game_sciences/game_one.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  final int rows = 7;
  final int cols = 7;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File _image;
  List<Widget> pieces = [];
  Image myImage;
  Size myImgSize;
  List<Piece> listPiece = [];
  final homePiece = BehaviorSubject<int>();

  Future getImage(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        pieces.clear();
      });

      splitImage(Image.file(File(image.path)), File(image.path));
    }
  }

  // we need to find out the image size, to be used in the PuzzlePiece widget
  Future<Size> getImageSize(File image) async {

    var decodedImage = await decodeImageFromList(image.readAsBytesSync());

    Size imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());

    return imageSize;
  }

  // here we will split the image into small pieces using the rows and columns defined above; each piece will be added to a stack
  void splitImage(Image image, File file) async {
    Size imageSize = await getImageSize(file);
    myImgSize = imageSize;
    myImage = image;

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        listPiece.add(Piece(x, y));
        pieces.add(
          PuzzlePiece(
              key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: this.bringToTop,
              sendToBack: this.sendToBack),
        );

        /*setState(() {
          pieces.add(PuzzlePiece(key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: this.bringToTop,
              sendToBack: this.sendToBack));
        });*/
      }
    }

    await Future.delayed(Duration(milliseconds: 500));

    homePiece.add(5);

  }

  // when the pan of a piece starts, we need to bring it to the front of the stack
  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  // when a piece reaches its final position, it will be sent to the back of the stack to not get in the way of other, still movable, pieces
  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
    });
  }

  @override
  void dispose() {
    homePiece.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<int>(
          stream: homePiece.stream,
          initialData: -1,
          builder: (context, snapshot) {
            final screenSize = MediaQuery.of(context).size;
            if(pieces.isNotEmpty && snapshot.data >= 0){
              return Stack(
                children: [
                  GameOne(
                    key: GlobalKey(),
                    imageSize: myImgSize,
                    pieceWidth: screenSize.width / widget.rows,
                    pieceHeight: (screenSize.height *
                        screenSize.width / myImgSize.width) / widget.cols,
                    piece: pieces[snapshot.data],
                    imgWidth: screenSize.width,
                    imgHeight: screenSize.height *
                        screenSize.width / myImgSize.width,
                    screenSize: screenSize,
                  ),
                ],
              );
            }
            return SizedBox();
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Camera'),
                        onTap: () {
                          getImage(ImageSource.camera);
                          // this is how you dismiss the modal bottom sheet after making a choice
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.image),
                        title: Text('Gallery'),
                        onTap: () {
                          getImage(ImageSource.gallery);
                          // dismiss the modal sheet
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
          );
        },
        tooltip: 'New Image',
        child: Icon(Icons.add),
      ),
    );
  }

}
