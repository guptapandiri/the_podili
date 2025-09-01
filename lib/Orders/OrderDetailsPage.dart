import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/delivery_timeline.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Orders/simpleOrderCart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .doc(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
                print(dataMap);
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                " Order Total : ₹ " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order ID: " + orderID),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]) *
                                              1000)),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Preferred Time to Deliver : ${dataMap['prefferedTime']}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Order Info : ${dataMap['cartInfo']}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Card(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ExpansionTile(
                              title: Text("Track Your Order "),
                              children: [
                                dataMap['cancellationStatus'] ==
                                            'notCancelled' &&
                                        dataMap['adminOrderCancellationStatus'] ==
                                            'notCancelled'
                                    ? TimelineDelivery(
                                        orderStatus: dataMap['orderStatus'])
                                    : Text(
                                        "Order Cancelled",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      )
                              ],
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? SimpleOrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                      orderId: orderID,
                                      orderTime: dataMap["orderTime"],
                                      cancellationStatus:
                                          dataMap['cancellationStatus'])
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

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
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 14.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  final String orderId;
  final String orderTime;
  final String cancellationStatus;

  ShippingDetails(
      {Key key,
      this.model,
      this.orderId,
      this.orderTime,
      this.cancellationStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
          child: Text(
            "Shipment Details :",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin Code",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: InkWell(
                  child: cancellationStatus == 'notCancelled'
                      ? Container()
                      : Text(
                          "Order Cancelled",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              getMinutesfromOrderTime(int.parse(orderTime),
                      DateTime.now().millisecondsSinceEpoch)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black87,
                        primary: Colors.redAccent,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 40.0, 50),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      onPressed: () {
                        cancelOrder(context, orderId, int.parse(orderTime));
                      },
                      child: Text(
                        'Cancel Order',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  bool getMinutesfromOrderTime(int orderTime, int currentTime) {
    int difference;
    double difference_minutes;
    int one_day = 1000 * 60 * 60 * 24;

    print(orderTime);
    print(currentTime);

    difference = currentTime - orderTime;

    difference_minutes = (difference / one_day) * 24 * 60;
    print((difference / one_day) * 24 * 60);

    return 5 > difference_minutes;
  }

  confirmeduserOrderReceived(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(
            EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .update({"userOrderConfirmation": "Received"});

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => MyOrders());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Received, Confirmed.");
  }

  cancelOrder(BuildContext context, String mOrderId, int orderTime) {
    if (getMinutesfromOrderTime(
        orderTime, DateTime.now().millisecondsSinceEpoch)) {
      EcommerceApp.firestore
          .collection(EcommerceApp.collectionUser)
          .doc(
              EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .collection(EcommerceApp.collectionOrders)
          .doc(mOrderId)
          .update({"cancellationStatus": "cancelled"});

      getOrderId = "";

      Route route = MaterialPageRoute(builder: (c) => MyOrders());
      Navigator.pushReplacement(context, route);

      Fluttertoast.showToast(msg: "Order has been Canceled.");
    }
  }
}
