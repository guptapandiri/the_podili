import 'package:e_shop/Admin/addNewItem.dart';
import 'package:e_shop/Admin/adminDeliveredOrders.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/displayItems.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Orders/delivery_timeline.dart';
import 'package:e_shop/Services/serviceRequests.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/policies/privacypolicy.dart';
import 'package:e_shop/policies/refundpolicy.dart';
import 'package:e_shop/policies/termsofservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../PhoneAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(EcommerceApp.sharedPreferences!.getString(EcommerceApp.isAdmin));
    print('Weber');

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.yellow.shade300, Colors.yellow.shade300],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                // Material(
                //   borderRadius: BorderRadius.all(Radius.circular(80.0)),
                //   elevation: 8.0,
                //   child: Container(
                //     height: 160.0,
                //     width: 160.0,
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         EcommerceApp.sharedPreferences
                //             .getString(EcommerceApp.userAvatarUrl),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Welcome User",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontFamily: "Signatra"),
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.yellow.shade300, Colors.yellow.shade300],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.list, color: Colors.black),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.black),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.search, color: Colors.black),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.add_location, color: Colors.black),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                  },
                ),

                EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.isAdmin) ==
                        '1'
                    ? Container(
                        child: Column(
                          children: [
                            Text(
                              "Admin Dashboard",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35.0,
                                  fontFamily: "Signatra"),
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            ListTile(
                              leading: Icon(Icons.add, color: Colors.black),
                              title: Text(
                                "Add A New Product",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => AddNewItem());
                                Navigator.push(context, route);
                              },
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            ListTile(
                              leading: Icon(Icons.edit, color: Colors.black),
                              title: Text(
                                "Update Product",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => DisplayItems());
                                Navigator.push(context, route);
                              },
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            ListTile(
                              leading: Icon(Icons.list, color: Colors.black),
                              title: Text(
                                "Manage Orders",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => AdminShiftOrders());
                                Navigator.push(context, route);
                              },
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            ListTile(
                              leading: Icon(Icons.done, color: Colors.black),
                              title: Text(
                                "Delivered Orders",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => AdminDeliveredOrders());
                                Navigator.push(context, route);
                              },
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            ListTile(
                              leading:
                                  Icon(Icons.build_sharp, color: Colors.black),
                              title: Text(
                                "Service Requests",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => ServiceRequests());
                                Navigator.push(context, route);
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(),

                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.security, color: Colors.black),
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _logout();
                    Route route =
                        MaterialPageRoute(builder: (_) => PrivacyPolicy());
                    Navigator.push(context, route);
                    // EcommerceApp.auth.signOut().then((c) {
                    //   Route route =
                    //       MaterialPageRoute(builder: (c) => AuthenticScreen());
                    //   Navigator.pushReplacement(context, route);
                    // });
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.policy, color: Colors.black),
                  title: Text(
                    "Return Policy",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _logout();
                    Route route =
                        MaterialPageRoute(builder: (_) => ReturnPolicy());
                    Navigator.push(context, route);
                    // EcommerceApp.auth.signOut().then((c) {
                    //   Route route =
                    //       MaterialPageRoute(builder: (c) => AuthenticScreen());
                    //   Navigator.pushReplacement(context, route);
                    // });
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.file_copy, color: Colors.black),
                  title: Text(
                    "Terms of Service",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _logout();
                    Route route =
                        MaterialPageRoute(builder: (_) => TermsofServices());
                    Navigator.push(context, route);
                    // EcommerceApp.auth.signOut().then((c) {
                    //   Route route =
                    //       MaterialPageRoute(builder: (c) => AuthenticScreen());
                    //   Navigator.pushReplacement(context, route);
                    // });
                  },
                ),
                Divider(
                  height: 5.0,
                  color: Colors.white,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.black),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _logout();
                    Route route =
                        MaterialPageRoute(builder: (_) => PhoneAuth());
                    Navigator.pushAndRemoveUntil(
                        context, route, (route) => false);
                    // EcommerceApp.auth.signOut().then((c) {
                    //   Route route =
                    //       MaterialPageRoute(builder: (c) => AuthenticScreen());
                    //   Navigator.pushReplacement(context, route);
                    // });
                  },
                )
                // Divider(
                //   height: 10.0,
                //   color: Colors.white,
                //   thickness: 6.0,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> _logout() async {
  /// Method to Logout the `User` (`_firebaseUser`)
  try {
    // signout code
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
  }
}
