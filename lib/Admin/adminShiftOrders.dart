import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/order.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/loadingWidget.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  DocumentSnapshot documentSnapshot;
  List<OrderModel> dataOrders;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: MyDrawer(),
          body: Container(
            // child: ListView.builder(itemBuilder: itemBuilder),

            child: FutureBuilder(
              future: getDocuments(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return snapshot.hasData? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (c, index){
                    return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("shortInfo", whereIn: snapshot.data()![index].productIDs)
                            .getDocuments(),

                        builder: (c, snap){

                          print(snapshot.data()![index].orderID);
                          print(snapshot.data()![index].orderBy);

                          return snap.hasData
                              ? AdminOrderCard(
                            itemCount: snap.data.documents.length,
                            data: snap.data.documents,
                            orderID: snapshot.data()![index].orderID,
                            orderStatus: snapshot.data()![index].orderStatus,
                            cancellationStatus: snapshot.data()![index].cancellationStatus,
                            orderBy: snapshot.data()![index].orderBy,
                            addressID: snapshot.data()![index].addressID,
                            adminOrderCancellationStatus: snapshot.data()![index].adminOrderCancellationStatus,
                            totalAmount: snapshot.data()![index].totalAmount.toString(),
                          )
                              : Center(child: circularProgress(),);
                        }

                    );
                  },
                ):Center(
                  child: Container(
                    child: CupertinoActivityIndicator( radius: 30,),
                  ),
                );
              },
            ),

            //   child: MaterialButton(
            //     onPressed: (){
            //      print(getDocuments());
            //     },
            //     child: Text("Yup!"),
            //   ),
            // )
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection(EcommerceApp.collectionUser)
            //       .snapshots(),
            //
            //   // builder: (c, snapshot){
            //   //
            //   //   print(snapshot.data.documents[9].data['uid']);
            //   //   //
            //   //   // return snapshot.hasData?
            //   //   //
            //   //   //     : Center(child: circularProgress(),);
            //   // }
            //
            // ),
          ),
        )
    );
  }

  Future<List<OrderModel>> getDocuments() async {
    int i = 0;

    List<DocumentSnapshot> snaps = await FirebaseFirestore.instance
        .collection("users")
        .getDocuments()
        .then((value) => value.documents);
    List<OrderModel> orders = [];

    // print(snaps[0].data.collection("orders"));

    for (i = 0; i < snaps.length; i++) {
      print(snaps[i].data["uid"]);
      List weber = await EcommerceApp.firestore
          .collection(EcommerceApp.collectionUser)
          .doc(snaps[i].data["uid"])
          .collection(EcommerceApp.collectionOrders)
          .orderBy('orderTime', descending: true)
          .getDocuments()
          .then((value) => value.documents);
      // print(element.data['paymentDetails']);
      weber.length != 0
          ? weber.forEach((element) {

            if(element.data['orderStatus']!='delivered'){
              print('Jai Bolo Ganesh Maharaj ki !!');
              print(element.data);
              orders.add(OrderModel.fromJson(element.data));
            }
      })
          : print('bla');

      // orders.add(element.data);
      // print(element.data.runtimeType);
      // weber.length!=0? weber.forEach((element) {orders.add(element);}) : print('');
    }

    print(orders.length);

    return orders;
  }
}
