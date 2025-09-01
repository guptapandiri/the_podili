import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Services/userService.dart';
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
import 'home.dart';
import 'package:new_version/new_version.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion( context:context, androidId: 'com.muhammadali.eshop');
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(status);
    print(" DEVICE " + status.localVersion);
    print(" STORE " + status.storeVersion);
  }

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
                  fontSize: 24.0,
                  color: Colors.black,
                  fontFamily: "Goblin One"),
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
            SliverToBoxAdapter(
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      constraints: new BoxConstraints.expand(
                                          height: 200.0, width: 300),
                                      alignment: Alignment.bottomLeft,
                                      padding: new EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: new DecorationImage(
                                          image: new NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/slider%2Fslider1.jpg?alt=media&token=415ff589-df7d-4a89-b206-7f68c1785ca5'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text('')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      constraints: new BoxConstraints.expand(
                                          height: 200.0, width: 300),
                                      alignment: Alignment.bottomLeft,
                                      padding: new EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: new DecorationImage(
                                          image: new NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/slider%2Fslider2.jpg?alt=media&token=32f94291-e89f-4a18-9bdb-c356f7b720af'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text('')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      constraints: new BoxConstraints.expand(
                                          height: 200.0, width: 300),
                                      alignment: Alignment.bottomLeft,
                                      padding: new EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: new DecorationImage(
                                          image: new NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/slider%2Fslider3.jpg?alt=media&token=a8a03af7-41a6-4437-90d7-c4d1589df544'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text('')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      constraints: new BoxConstraints.expand(
                                          height: 200.0, width: 300),
                                      alignment: Alignment.bottomLeft,
                                      padding: new EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: new DecorationImage(
                                          image: new NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/slider%2Fslider4.jpg?alt=media&token=e4b2c257-6879-48f4-982f-4f7d150f80e3'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text('')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      constraints: new BoxConstraints.expand(
                                          height: 200.0, width: 300),
                                      alignment: Alignment.bottomLeft,
                                      padding: new EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: new DecorationImage(
                                          image: new NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/slider%2Fslider5.jpg?alt=media&token=44e3583e-6ea2-4dc6-bb02-d7c9464c4fce'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text('')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Food')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Ffood-icon.jpeg?alt=media&token=35a92da8-ad1a-4ef5-adc9-bbef64ec9602',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Food')
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Groceries')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fgroceries-icon.jpg?alt=media&token=3bb36283-cc43-4f24-9bad-49c004353aa0',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Groceries')
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Vegetables Fruits')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fvegetables-icon.png?alt=media&token=53c9fb50-87ce-43c6-8061-c7dd784f265b',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Vegetables \n & Fruits', textAlign: TextAlign.center,)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Meat')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fmeat-icon.jpeg?alt=media&token=52d0f233-f78c-44c9-b0ac-2be5e220a215',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Eggs & Meat')
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('LadiesEmporium')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fladiesemporium.jpg?alt=media&token=7ee1f15b-b744-4557-a5ad-da5c47111fe1',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('LadiesEmporium')
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Milk Products')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fmilk-icon.png?alt=media&token=fd269c14-651d-4801-bd3b-973fe77ce48d',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Milk & Products')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Sai Ganesh Dry Fruits')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fdry_fruits.jpg?alt=media&token=21c522ec-b6f8-412c-9d9d-f96bdbae39b9',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Sai Ganesh \n Dry Fruits', textAlign: TextAlign.center,)
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Todays Special')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fspecial.jpg?alt=media&token=01b20447-57f7-42ce-92c1-c58350d4b441',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text("Today's Special")
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text('Tap'),
                                          // ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home('Bakery Items Cool Drinks')),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fbakery.jpg?alt=media&token=8012c9aa-7722-42fd-ac93-12fd3786bce1',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Bakery Items & \n Cool Drinks', textAlign: TextAlign.center,)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserService()),
                                          );
                                        },
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectpodili.appspot.com/o/icon%2Fservices.png?alt=media&token=0977ff66-b869-4279-93ca-5b0ae86832cb',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Services')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
            // StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection("items")
            //         .limit(15)
            //         .orderBy("publishedDate", descending: true)
            //         .snapshots(),
            //     builder: (context, dataSnapshot) {
            //       return !dataSnapshot.hasData
            //           ? SliverToBoxAdapter(
            //               child: Center(
            //                 child: circularProgress(),
            //               ),
            //             )
            //           : SliverStaggeredGrid.countBuilder(
            //               crossAxisCount: 2,
            //               staggeredTileBuilder: (c) => StaggeredTile.fit(1),
            //               itemBuilder: (context, index) {
            //                 ItemModel model = ItemModel.fromJson(
            //                     dataSnapshot.data!.docs[index].data());
            //                 return sourceinfogrid(model, context);
            //               },
            //               itemCount: dataSnapshot.data.documents.length,
            //             );
            //     }),
          ],
        ),
      ),
    );
  }
}

Widget sourceinfogrid(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Card(
          child: Column(children: <Widget>[
        Container(
          height: 140,
          width: double.infinity,
          child: Image.network(
            model.thumbnailUrl,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 2),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 3.0,
              ),
              Text(
                model.title,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Price: ₹" + model.price.toString(),
                style: TextStyle(fontSize: 16, color: Colors.green.shade700),
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
                            Route route =
                                MaterialPageRoute(builder: (c) => StoreHome());
                            Navigator.push(context, route);
                          },
                        )),
            ],
          ),
        ),
      ])),
    ),
  );
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
                                r"Price: ₹",
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

Widget sourceinfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
        Navigator.push(context, route);
      },
      splashColor: Colors.pink,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5)),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  constraints:
                      new BoxConstraints.expand(height: 160.0, width: 160),
                  alignment: Alignment.bottomLeft,
                  padding:
                      new EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: new DecorationImage(
                      image: new NetworkImage(model.thumbnailUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     Row(
                  //       children: <Widget>[
                  //         Container(
                  //           padding: EdgeInsets.only(
                  //               left: 5, right: 5, top: 5, bottom: 5),
                  //           decoration: BoxDecoration(
                  //               color: Colors.black,
                  //               borderRadius: BorderRadius.circular(5.0)),
                  //           child: new Text('Category',
                  //               style: new TextStyle(
                  //                   fontSize: 12.0, color: Colors.white)),
                  //         ),
                  //       ],
                  //     ),
                  //     Container(
                  //       padding: EdgeInsets.only(
                  //           left: 5, right: 10, top: 5, bottom: 5),
                  //       decoration: BoxDecoration(
                  //           color: Colors.blue,
                  //           borderRadius: BorderRadius.circular(5.0)),
                  //       child: new Text('15% OFF - no code required',
                  //           style: new TextStyle(
                  //               fontSize: 12.0, color: Colors.white)),
                  //     ),
                  //   ],
                  // ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            "\u20B9" + model.price.toString(),
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 3.0,
                          ),
                          Container(
                              height: 30,
                              width: 30,
                              color: Colors.yellow,
                              child: IconButton(
                                iconSize: 15,
                                icon: Icon(Icons.remove),
                                onPressed: () {},
                                color: Colors.black,
                                splashColor: Colors.yellow,
                              )),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(" 1 "),
                          SizedBox(
                            width: 3.0,
                          ),
                          Container(
                              height: 30,
                              width: 30,
                              color: Colors.yellow.shade300,
                              child: IconButton(
                                iconSize: 15,
                                icon: Icon(Icons.add),
                                onPressed: () {},
                                color: Colors.black,
                                splashColor: Colors.yellow,
                              )),
                          SizedBox(
                            width: 35.0,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: removeCartFunction == null
                                  ? Container(
                                      child: IconButton(
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.pinkAccent,
                                      ),
                                      onPressed: () {
                                        checkItemInCart(
                                            model.shortInfo, context);
                                      },
                                    ))
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Divider(color: Color(0xFFF2F2F2)),
              // SizedBox(
              //   height: 1,
              // ),
            ],
          ),
        ),
      ));
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
    Fluttertoast.showToast(
        msg: "Item Added to Cart Successfully.",
        backgroundColor: Colors.black,
        textColor: Colors.white);

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
