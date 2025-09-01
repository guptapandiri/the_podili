import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'storehome.dart';

double width;

class Home extends StatefulWidget {
  final String category; //if you have multiple values add here
  Home(this.category, {Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.yellow.shade300, Colors.yellow.shade300],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            "PODILI - ALL IN ONE",
            style: TextStyle(
                fontSize: 24.0, color: Colors.black, fontFamily: "Goblin One"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, route);
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Positioned(
                          top: 3.0,
                          bottom: 4.0,
                          left: 4.0,
                          child: Consumer<CartItemCounter>(
                              builder: (context, counter, _) {
                            return Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userCartList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            );
                          }))
                    ],
                  ),
                )
              ],
            )
          ]),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("category", isEqualTo: widget.category)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverMasonryGrid.count(
                        crossAxisCount: 1,
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data!.docs[index].data());
                          return sourceInfo(model, context);
                        },
                        childCount: dataSnapshot.data!.docs.length,
                      );
              })
        ],
      ),
    ));
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.pink,
    child: !model.isHide? Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 50.0),
                      Expanded(
                        child: Text(
                          model.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.shortInfo,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(
                                r"Price: ₹ ",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (model.price).toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.pinkAccent,
                            ),
                            onPressed: () {
                              checkItemInCart(model.shortInfo, context);
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.pinkAccent,
                            ),
                            onPressed: () {
                              removeCartFunction();
                              Route route = MaterialPageRoute(
                                  builder: (c) => StoreHome());
                              Navigator.push(context, route);
                            },
                          )),
                Divider(
                  height: 5.0,
                  color: Colors.pink,
                )
              ],
            ))
          ],
        ),
      ),
    ) : Container(),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(imgPath,
          height: 150.0, width: width * .34, fit: BoxFit.fill),
    ),
  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added to CartSuccessfully.");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
