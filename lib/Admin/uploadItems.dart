import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  String _category;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  takeImage(context);
                },
                child: Text(
                  "Add New Items",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  primary: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
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

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        file = imageFile;
      });
    }
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    XFile? pickedFile = await ImagePicker()
        .pickImage(
          source: ImageSource.gallery,
        );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        file = imageFile;
      });
    }
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New Product",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (uploading) {
              } else {
                uploadImageAndSaveItemInfo();
              }
              // uploading ? null : () => uploadImageAndSaveItemInfo();
            },
            child: Text("Add",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
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
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
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
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      //_category = "";
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
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
      "category": _category,
      "quantity": quantity
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _category = "";
      quantity = 0;
    });
  }
}
