import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/updateItem.dart';
import 'package:e_shop/Services/viewRequest.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';

class ServiceRequests extends StatefulWidget {
  @override
  _ServiceRequestsState createState() => _ServiceRequestsState();
}

class _ServiceRequestsState extends State<ServiceRequests> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: MyDrawer(),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('services').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: snapshot.data.documents.map((document) {
                    return  ListTile(
                      onTap: (){
                        viewRequest(document.documentID);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fservices.png?alt=media&token=0977ff66-b869-4279-93ca-5b0ae86832cb'),
                      ),
                      title: Text("Name : " + document["name"]),
                      subtitle: Text((() {
                        if(document["category"] == null){
                          return "Service : not selected";}

                        return "Service : " + document["category"];
                      })()),
                      // trailing: Wrap(
                      //   spacing: 22,
                      //   children: [
                      //     IconButton(
                      //         icon: Icon(
                      //           Icons.edit,
                      //           color: Colors.grey,
                      //         ),
                      //         onPressed: () {
                      //           editItem(document.documentID);
                      //         }),
                      //
                      //   ],
                      // ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ));
  }

  void viewRequest(String documentID) {
    Route route =
    MaterialPageRoute(builder: (c) => ViewServiceRequest( serviceID: documentID,));
    Navigator.push(context, route);
  }

}
