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

class UserService extends StatefulWidget {
  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService> {
  final formKey = GlobalKey<FormState>();
  String name;
  String contactNumber;
  String query;
  String serviceId = DateTime.now().millisecondsSinceEpoch.toString();
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
              Container( margin: EdgeInsets.only(top: 20.0 ), child: Text("Submit Your Request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),)),

              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    children: [

                      nameField(),
                      SizedBox(
                        height: 16,
                      ),
                      contactNo(),
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
                            'Plumbing',
                            'Electrical',
                            'Painting',
                            'House Keeping',
                            'Other'
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

  Widget nameField() {
    return TextFormField(
      decoration:
      InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => name = value),
      validator: (value) {
        if (value.length < 4) {
          return "Name must be more than 4 characters";
        } else {
          return null;
        }
      },
    );
  }

  Widget contactNo() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Contact Number', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => contactNumber = value),
      validator: (value) {
        if (value.length < 10) {
          return "Contact Number Must be 10 Characters";
        } else {
          return null;
        }
      },
    );
  }


  Widget longDescription() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter Your Query', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => query = value),
      maxLines: 5,
      keyboardType: TextInputType.multiline,

    );
  }

  Widget submitButton() {

    return ButtonWidget(text: 'Submit Item',
        onClicked: () {
          final isValid =  formKey.currentState.validate();
          if(isValid){
            formKey.currentState.save();
            saveItemInfo();
          }
        });
  }


  saveItemInfo() {
    final servicesRef = FirebaseFirestore.instance.collection("services");
    servicesRef.doc(serviceId).set({
      "name" : name,
      "contactNumber" : contactNumber,
      "category": _category,
      "description": query
    }).whenComplete(() {
      Route route =
      MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);



    });

    setState(() {
      serviceId = DateTime.now().millisecondsSinceEpoch.toString();
      name="";
      contactNumber="";
      query="";
    });


  }
}
