import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/button_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';

class AddNewItem extends StatefulWidget {
  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "ADD NEW ITEM",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  )),
              file != null
                  ? Container(
                      height: 230.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(file), fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.image_rounded,
                          color: Colors.green,
                          size: 200.0,
                        ),
                      ],
                    ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    takeImage(context);
                  },
                  child: Text(
                    "Upload Image",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
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
                      shortInfoField(),
                      SizedBox(
                        height: 16,
                      ),
                      titleField(),
                      SizedBox(
                        height: 16,
                      ),
                      priceField(),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton<String>(
                          value: _category,
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
                          ].map<DropdownMenuItem<String>>((String value) {
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
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      longDescription(),
                      SizedBox(
                        height: 16,
                      ),
                      submitButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

    setState(() {
      file = imageFile;
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

  Widget titleField() {
    return TextFormField(
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

  Widget shortInfoField() {
    return TextFormField(
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

  Widget priceField() {
    return TextFormField(
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

  Widget longDescription() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Description', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => description = value),
      maxLines: 5,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget submitButton() {
    SnackBar imageRequired = SnackBar(
      content: Text('Image is Required'),
      backgroundColor: Colors.redAccent,
    );

    return ButtonWidget(
        fontSize: 24,
        text: 'Submit Item',
        onClicked: () {
          final isValid = formKey.currentState.validate();
          if (isValid) {
            formKey.currentState.save();
            if (file == null) {
              ScaffoldMessenger.of(context).showSnackBar(imageRequired);
            } else if (uploading == false) {
              uploadImageAndSaveItemInfo();
            }
          }
        });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    uploadItemImage(file);
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
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

  saveItemInfo(String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(productId).set({
      "shortInfo": shortInfo.trim(),
      "longDescription": description.trim(),
      "price": int.parse(price),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": title.trim(),
      "isHide": false,
      "category": _category,
      "quantity": quantity
    }).whenComplete(() {
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
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
