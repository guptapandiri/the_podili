import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'Store/home.dart';
import 'PhoneAuth.dart';

import 'package:e_shop/Services/AuthService.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
          title: 'Mana Podili',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 3), () async {
      if (EcommerceApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => PhoneAuth());
        //Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/podili_village.jpg"),
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/5,),
            Image.asset(
              "assets/podili_icon.png",
              width: 200,
              height: 200,
            ),
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            Text(
              "Welcome to Podili All in One",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width/17,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/4,
            ),

            Text(
              "Developed by",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(
              height: 10,
            ),

            Text(
              "❤",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(
              height: 20,
            ),
            Text(
              "Drugtive Technologies PVT LTD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));
  }
}
