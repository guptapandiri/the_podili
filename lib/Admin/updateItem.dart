import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/button_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';

import 'displayItems.dart';

class UpdateItem extends StatefulWidget {
  final String itemID;

  UpdateItem({Key key, this.itemID}) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final formKey = GlobalKey<FormState>();
  String shortInfo;
  String title;
  String category;
  String description;
  String price;
  File file;
  bool uploading = false;
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  int quantity = 0;
  String _category;
  bool categoryUpdated = false;
  bool imageUpdated = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection('items')
                .doc(widget.itemID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
                print(dataMap['price'].runtimeType);
              }

              return snapshot.hasData
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Text(
                                "UPDATE ITEM",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 26),
                              )),
                          Center(
                            child: Container(
                              height: 230.0,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: !imageUpdated
                                                ? NetworkImage(
                                                    dataMap['thumbnailUrl'])
                                                : FileImage(file),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                takeImage(context);
                              },
                              child: Text(
                                "Upload Image",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9.0)),
                                primary: Colors.green,
                              ),
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  shortInfoField(dataMap['shortInfo']),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  titleField(dataMap['title']),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  priceField(dataMap['price'].toString()),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: DropdownButton<String>(
                                      value: _category != null
                                          ? _category
                                          : dataMap['category'],
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.black),

                                      items: <String>[
                                        'Food',
                                        'Groceries',
                                        'Meat',
                                        'Vegetables',
                                        'Fast Food',
                                        'Ice Creams',
                                        'LadiesEmporium',
                                        'Cool Drinks',
                                        'Vegetables Fruits',
                                        'Bakery Items Cool Drinks',
                                        'Sai Ganesh Dry Fruits',
                                        'Todays Special'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Please choose Category",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          _category = value;
                                          categoryUpdated = true;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  longDescriptionField(
                                      dataMap['longDescription']),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  submitButton(snapshot.data.documentID)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CupertinoActivityIndicator(
                        radius: 30,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget updateItemData(Map data) {
    print(data['title']);
    return Container();
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

    setState(() {
      file = imageFile;
      imageUpdated = true;
    });
    }
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

    setState(() {
      file = imageFile;
      imageUpdated = true;
    });
    }
  }

  takeImage(mContext) {
    return showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select From Gallery",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget titleField(String titleText) {
    return TextFormField(
      initialValue: titleText,
      decoration:
          InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => title = value),
      validator: (value) {
        if (value.length < 4) {
          return "Title must be more than 4 characters";
        } else {
          return null;
        }
      },
    );
  }

  Widget shortInfoField(String shortInfoText) {
    return TextFormField(
      enabled: false,
      initialValue: shortInfoText,
      decoration: InputDecoration(
          labelText: 'Short Info', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => shortInfo = value),
      validator: (value) {
        if (value.length < 4) {
          return "Short Info must be more than 4 characters";
        } else {
          return null;
        }
      },
    );
  }

  Widget priceField(String priceText) {
    return TextFormField(
      initialValue: priceText,
      decoration:
          InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => price = value),
      validator: (value) {
        if (value.length <= 0) {
          return "Price is Required";
        } else {
          return null;
        }
      },
    );
  }

  Widget longDescriptionField(String longDescriptionText) {
    return TextFormField(
      initialValue: longDescriptionText,
      decoration: InputDecoration(
          labelText: 'Description', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => description = value),
      maxLines: 5,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget submitButton(String productNo) {
    return ButtonWidget(
        text: 'Submit Item',
        onClicked: () {
          // formKey.currentState.save();
          //
          // print(title);
          // print(shortInfo);
          // print(description);
          // print(price);
          // print(_category);

          final isValid = formKey.currentState.validate();
          if (isValid) {
            formKey.currentState.save();
            if (imageUpdated && categoryUpdated) {
              uploadImageAndSaveItemInfo(productNo);
            } else if (imageUpdated && !categoryUpdated) {
              uploadImageAndSaveItemInfo(productNo);
            } else if (!imageUpdated && categoryUpdated) {
              print(categoryUpdated);
              print(_category);
              updateCategoryAndInfo(productNo);
            } else if (!imageUpdated && !categoryUpdated) {
              updateItemInfo(productNo);
            }
          }
        });
  }

  uploadImageAndSaveItemInfo(String productNo) async {
    setState(() {
      uploading = true;
    });

    uploadItemImage(file);
    String imageDownloadUrl = await uploadItemImage(file);

    if (imageUpdated && categoryUpdated) {
      updateImageAndCategory(imageDownloadUrl, productNo);
    } else if (imageUpdated && !categoryUpdated) {
      updateImageAndInfo(imageDownloadUrl, productNo);
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  updateImageAndInfo(String downloadUrl, String documentID) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(documentID).update({
      "longDescription": description.trim(),
      "price": int.parse(price),
      "thumbnailUrl": downloadUrl,
      "title": title.trim(),
      "lastUpdated": DateTime.now(),
    }).whenComplete(() {
      Route route = MaterialPageRoute(builder: (c) => DisplayItems());
      Navigator.pushReplacement(context, route);
    });

    setState(() {
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      title = "";
      quantity = 0;
    });
  }

  updateItemInfo(String documentID) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(documentID).update({
      "longDescription": description.trim(),
      "price": int.parse(price),
      "lastUpdated": DateTime.now(),
      "title": title.trim(),
    }).whenComplete(() {
      Route route = MaterialPageRoute(builder: (c) => DisplayItems());
      Navigator.pushReplacement(context, route);
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      title = "";
      quantity = 0;
    });
  }

  updateCategoryAndInfo(String documentID) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(documentID).update({
      "longDescription": description.trim(),
      "price": int.parse(price),
      "lastUpdated": DateTime.now(),
      "title": title.trim(),
      "category": _category
    }).whenComplete(() {
      Route route = MaterialPageRoute(builder: (c) => DisplayItems());
      Navigator.pushReplacement(context, route);
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      title = "";
      quantity = 0;
    });
  }

  updateImageAndCategory(String documentID, String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(documentID).update({
      "longDescription": description.trim(),
      "price": int.parse(price),
      "thumbnailUrl": downloadUrl,
      "category": _category,
      "lastUpdated": DateTime.now(),
      "title": title.trim(),
    }).whenComplete(() {
      Route route = MaterialPageRoute(builder: (c) => DisplayItems());
      Navigator.pushReplacement(context, route);
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      title = "";
      quantity = 0;
    });
  }
}
