import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/updateItem.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayItems extends StatefulWidget {
  @override
  _DisplayItemsState createState() => _DisplayItemsState();
}

class _DisplayItemsState extends State<DisplayItems> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').orderBy("publishedDate", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((document) {
                return  ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(document['thumbnailUrl']),
                  ),
                  title: Text(document["title"]),
                  subtitle: Text("Price : " + document['price'].toString()),
                  trailing: Wrap(
                    spacing: 22,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            editItem(document.documentID);
                          }),
                      document['isHide'] ? IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            showItem(document.documentID);
                          }) : IconButton(
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            hideItem(document.documentID);
                          })  ,
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    ));
  }

  void editItem(String documentID) {
    Route route =
    MaterialPageRoute(builder: (c) => UpdateItem( itemID: documentID,));
    Navigator.push(context, route);
  }

  void hideItem(String documentID) {
    FirebaseFirestore.instance
        .collection('items')
        .doc(documentID)
        .update({"isHide": true});
    Fluttertoast.showToast(
        msg: "The Item is Hidden to Users",
        timeInSecForIos: 4);
  }

  void showItem(String documentID) {
    FirebaseFirestore.instance
        .collection('items')
        .doc(documentID)
        .update({"isHide": false});
    Fluttertoast.showToast(
        msg: "The Item is Visible to Users",
        timeInSecForIos: 4);
  }
}
