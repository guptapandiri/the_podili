import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewServiceRequest extends StatefulWidget {
  final String serviceID;

  ViewServiceRequest({Key key, this.serviceID}) : super(key: key);

  @override
  _ViewServiceRequestState createState() => _ViewServiceRequestState();
}

class _ViewServiceRequestState extends State<ViewServiceRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection('services')
                .doc(widget.serviceID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }

              return snapshot.hasData
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Text(
                                "VIEW SERVICE REQUEST",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 26),
                              )),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Name  : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text((() {
                                      if (dataMap['name'] == null) {
                                        return "No Name";
                                      }

                                      return dataMap['name'];
                                    })(), style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Contact Details : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),

                                    Text((() {
                                      if (dataMap['contactNumber'] == null) {
                                        return "No Number";
                                      }

                                      return dataMap['contactNumber'];
                                    })(), style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Service : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),

                                    Text((() {
                                      if (dataMap['category'] == null) {
                                        return "No Category Selected";
                                      }

                                      return dataMap['category'];
                                    })(), style: TextStyle(fontSize: 20)),
                                    // Text(
                                    //   dataMap['category'].toString().length != 0
                                    //       ? dataMap['category']
                                    //       : "No Category Selected",
                                    //   style: TextStyle(fontSize: 20),
                                    // )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Description : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text((() {
                                  if (dataMap['description'] == null) {
                                    return "No Description";
                                  }
                                  return dataMap['description'];
                                })(), style: TextStyle(fontSize: 20)),
                              ],
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
}
