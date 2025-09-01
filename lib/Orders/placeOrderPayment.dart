import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/button_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'myOrders.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final AddressModel model;

  PaymentPage({Key key, this.addressId, this.totalAmount, this.model})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final formKey = GlobalKey<FormState>();
  int _payment_method = 0;
  int discountAmount = 0;
  Razorpay _razorpay;
  TwilioFlutter twilioFlutter;
  String preferredTime = '7 AM';
  String couponCode;
  String successText;
  bool isDiscount = false;
  int i = 0;
  List productList =
      EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);
  List phonenumbers = ['+918501014199', '+919848208168', '+918106089784'];
  int deliveryCharges = int.parse(
      EcommerceApp.sharedPreferences!.getString(EcommerceApp.deliveryCharges));

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    setTiwilio();
  }

  void setTiwilio() async {
    DocumentSnapshot twilioCreds =
        await FirebaseFirestore.instance.collection('keys').doc('twilio').get();

    DocumentSnapshot phoneNumbersFB =
    await FirebaseFirestore.instance.collection('keys').doc('phoneNumbers').get();

    twilioFlutter = TwilioFlutter(
        accountSid: twilioCreds.data['accountSid'],
        authToken: twilioCreds.data['authToken'],
        twilioNumber: twilioCreds.data['twilioNumber']);

    phonenumbers = phoneNumbersFB.data['phoneNumbers'];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: Image.asset("images/cash.png"),
                // ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Proceed Checkout",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),

                Card(
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Order Total : ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${widget.totalAmount.toString()}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Delivery Charges : ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              // "20.0",
                              EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.deliveryCharges),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Divider(
                              height: 10,
                              thickness: 3,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Amount : ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${widget.totalAmount + int.parse(EcommerceApp.sharedPreferences!.getString(EcommerceApp.deliveryCharges))}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        isDiscount
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Discount Amount : ",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "- $discountAmount",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Divider(
                                        height: 10,
                                        thickness: 3,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Final Amount : ",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "${widget.totalAmount + int.parse(EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.deliveryCharges)) -discountAmount }",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Have a Coupon ?',
                                ),
                                onSaved: (value) =>
                                    setState(() => couponCode = value.trim()),
                                validator: (value) {
                                  if (value.length < 4) {
                                    return "Coupon Code must be more than 3 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              submitCoupon()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Choose Delivery Time : ",
                              style: TextStyle(fontSize: 20),
                            ),
                            DropdownButton<String>(
                              value: preferredTime,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  preferredTime = newValue;
                                });
                              },
                              items: <String>[
                                '7 AM',
                                '8 AM',
                                '9 AM',
                                '10 AM',
                                '11 AM',
                                '12 PM',
                                '1 PM',
                                '2 PM',
                                '3 PM',
                                '4 PM',
                                '5 PM',
                                '6 PM',
                                '7 PM',
                                '8 PM',
                                '9 PM'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                         Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Online Payment : ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Radio<int>(
                                        value: 1,
                                        groupValue: _payment_method,
                                        onChanged: (value) {
                                          setState(() {
                                            _payment_method = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Cash On Delivery : ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Radio<int>(
                                        value: 2,
                                        groupValue: _payment_method,
                                        onChanged: (value) {
                                          setState(() {
                                            _payment_method = value;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )

                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (_payment_method == 1) {
                        openCheckout();
                      } else if (_payment_method == 2) {
                        addOrderDetails();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select a Payment Method",
                            timeInSecForIos: 4);
                      }
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.purple,
                        backgroundColor: Colors.green,
                        elevation: 5,
                        textStyle: TextStyle(
                            fontSize: 24, fontStyle: FontStyle.italic)),
                    child: Text(
                      "Place Order",
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    ));
  }

  addOrderDetails() async {
    String productDescription = '';
    String orderID =
        EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID) +
            DateTime.now().millisecondsSinceEpoch.toString();

    for (i = 1; i < productList.length; i++) {
      productDescription = productDescription + productList[i] + ' ';
    }

    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount +
          int.parse(EcommerceApp.sharedPreferences
              .getString(EcommerceApp.deliveryCharges)) - discountAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      "orderID": orderID,
      "prefferedTime": preferredTime,
      "adminOrderCancellationStatus": "notCancelled",
      "cartInfo":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.cartInfo),
      EcommerceApp.cancellationStatus: "notCancelled",
      EcommerceApp.userOrderConfirmation: "Not Received",
      EcommerceApp.orderStatus: "placed",
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount +
          int.parse(EcommerceApp.sharedPreferences
              .getString(EcommerceApp.deliveryCharges)) - discountAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      "orderID": orderID,
      "prefferedTime": preferredTime,
      "adminOrderCancellationStatus": "notCancelled",
      "cartInfo":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.cartInfo),
      EcommerceApp.orderStatus: "placed",
      EcommerceApp.cancellationStatus: "notCancelled",
      EcommerceApp.userOrderConfirmation: "Not Received",
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {emptyCartNow()});

    if(isDiscount){
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .get();

      List couponHistory = userData.data['couponHistory'];

      couponHistory.add(couponCode.trim().toUpperCase());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .update({"couponHistory": couponHistory});


      phonenumbers.forEach((phone) {
        sendSms(phone,
            "${widget.model.name} has placed a discount order product : $productDescription with the coupon code $couponCode contact at ${widget.model.phoneNumber}");
      });

    }else{
      phonenumbers.forEach((phone) {
        sendSms(phone,
            "${widget.model.name} has ordered $productDescription at a price ${widget.totalAmount + int.parse(EcommerceApp.sharedPreferences!.getString(EcommerceApp.deliveryCharges))} with Cash on Delivery! contact at ${widget.model.phoneNumber}");
      });
    }

  }

  placeDiscountOrder() async {
    String productDescription = '';
    String orderID =
        EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID) +
            DateTime.now().millisecondsSinceEpoch.toString();

    for (i = 1; i < productList.length; i++) {
      productDescription = productDescription + productList[i] + ' ';
    }

    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount +
          int.parse(EcommerceApp.sharedPreferences
              .getString(EcommerceApp.deliveryCharges)) - discountAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      "orderID": orderID,
      "prefferedTime": preferredTime,
      "adminOrderCancellationStatus": "notCancelled",
      "cartInfo":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.cartInfo),
      EcommerceApp.cancellationStatus: "notCancelled",
      EcommerceApp.userOrderConfirmation: "Not Received",
      EcommerceApp.orderStatus: "placed",
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "FREE ORDER WITH COUPON",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {emptyCartNow()});

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(
            EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .get();

    List couponHistory = userData.data['couponHistory'];

    couponHistory.add(couponCode.trim().toUpperCase());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(
            EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .update({"couponHistory": couponHistory});

    phonenumbers.forEach((phone) {
      sendSms(phone,
          "${widget.model.name} has placed a discount order product : $productDescription with the coupon code $couponCode contact at ${widget.model.phoneNumber}");
    });

    _onOrderSuccess();
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);

    FirebaseFirestore.instance
        .collection("users")
        .doc(
            EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .update({EcommerceApp.userCartList: tempList}).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(
        msg: "Congratulations, your Order has been placed successfully.");

    // Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(
            EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(data['orderID'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(data['orderID'])
        .set(data);
    _onOrderSuccess();
  }

  void openCheckout() async {
    String productDescription = '';

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('keys').doc('razor_pay').get();

    String razorPayKey = snapshot.data()!['key'];

    for (i = 1; i < productList.length; i++) {
      productDescription = productDescription + productList[i] + ' ';
    }

    print(widget.model.phoneNumber);

    var options = {
      'key': razorPayKey,
      'amount': (widget.totalAmount - discountAmount +
              int.parse(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.deliveryCharges))) *
          100,
      'name': widget.model.name,
      'description': productDescription,
      'prefill': {
        'contact': widget.model.phoneNumber,
        'email': 'venkatsrinu601@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String productDescription = '';
    String orderID =
        EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID) +
            DateTime.now().millisecondsSinceEpoch.toString();

    for (i = 1; i < productList.length; i++) {
      productDescription = productDescription + productList[i] + ' ';
    }

    Fluttertoast.showToast(
        msg: "Payment Successful" + response.paymentId, timeInSecForIos: 4);

    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount +
          int.parse(EcommerceApp.sharedPreferences
              .getString(EcommerceApp.deliveryCharges)) - discountAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      "orderID": orderID,
      "adminOrderCancellationStatus": "notCancelled",
      "cartInfo":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.cartInfo),
      "prefferedTime": preferredTime,
      EcommerceApp.cancellationStatus: "notCancelled",
      EcommerceApp.userOrderConfirmation: "Not Received",
      EcommerceApp.orderStatus: "placed",
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Online Payment",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      'paymentId': response.paymentId
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount +
          int.parse(EcommerceApp.sharedPreferences
              .getString(EcommerceApp.deliveryCharges)) - discountAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      "orderID": orderID,
      "adminOrderCancellationStatus": "notCancelled",
      "cartInfo":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.cartInfo),
      "prefferedTime": preferredTime,
      EcommerceApp.orderStatus: "placed",
      EcommerceApp.cancellationStatus: "notCancelled",
      EcommerceApp.userOrderConfirmation: "Not Received",
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Online Payment",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      'paymentId': response.paymentId
    }).whenComplete(() => {emptyCartNow()});

    if(isDiscount){
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .get();

      List couponHistory = userData.data['couponHistory'];

      couponHistory.add(couponCode.trim().toUpperCase());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .update({"couponHistory": couponHistory});


      phonenumbers.forEach((phone) {
        sendSms(phone,
            "${widget.model.name} has placed a discount order product : $productDescription with the coupon code $couponCode contact at ${widget.model.phoneNumber}");
      });

    }else{
      phonenumbers.forEach((phone) {
        sendSms(phone,
            "${widget.model.name} has ordered $productDescription at a price ${widget.totalAmount + int.parse(EcommerceApp.sharedPreferences!.getString(EcommerceApp.deliveryCharges))} and paid online! contact at ${widget.model.phoneNumber}");
      });
    }







  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Not Done, Error in Payment" +
            response.code.toString() +
            " - " +
            response.message,
        timeInSecForIos: 4);
    _onOrderError();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  void sendSms(String number, String message) async {
    twilioFlutter.sendSMS(toNumber: number, messageBody: message);
  }

  Future<void> _onOrderSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                Text('Your Order has been Placed Successfully!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Home'),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
            ),
            TextButton(
              child: Text('My Orders'),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => MyOrders());
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onOrderError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                  size: 100,
                ),
                Text('Your Order has failed!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Home'),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              },
            ),
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget submitCoupon() {
    // SnackBar imageRequired = SnackBar(content: Text('Coupon is Empty'), backgroundColor: Colors.redAccent,);
    // ScaffoldMessenger.of(context).showSnackBar(imageRequired);
    return ButtonWidget(
        fontSize: 12,
        text: 'APPLY COUPON',
        onClicked: () async {
          final isValid = formKey.currentState.validate();
          if (isValid) {
            formKey.currentState.save();

            bool isExists = await checkRecordExists();

            if (isExists) {
              applyCoupon();
            } else {
              setState(() {
                isDiscount = false;
              });

              SnackBar couponNotExists = SnackBar(
                content: Text('The Coupon code is Invalid'),
                backgroundColor: Colors.redAccent,
              );
              ScaffoldMessenger.of(context).showSnackBar(couponNotExists);
            }

            // applyCoupon();

          }
        });
  }

  Future<bool> checkRecordExists() async {
    DocumentSnapshot couponSnapshot = await FirebaseFirestore.instance
        .collection('coupon_codes')
        .doc(couponCode.trim().toUpperCase())
        .get();
    return couponSnapshot.exists;
  }

  applyCoupon() async {
    DocumentSnapshot couponSnapshot = await FirebaseFirestore.instance
        .collection('coupon_codes')
        .doc(couponCode.trim().toUpperCase())
        .get();

    if(couponSnapshot.data['type']=="first"){

      successText = couponSnapshot.data['successText'];

      setState(() {
        discountAmount = couponSnapshot.data['discountAmount'];
      });

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
          .get();

      List couponHistory = userSnapshot.data['couponHistory'];
      String itemInfo = couponSnapshot.data['shortInfo'];
      int items = couponSnapshot.data['items'];
      List cartList =
      EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);

      if (items != cartList.length - 1) {
        setState(() {
          isDiscount = false;
        });

        SnackBar singleItem = SnackBar(
          content: Text('There can only be $items items in the cart'),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(singleItem);
      } else {
        if (checkItemExists(couponHistory, couponCode.trim().toUpperCase())) {
          setState(() {
            isDiscount = false;
          });

          SnackBar couponExists = SnackBar(
            content: Text('The Coupon is already used!'),
            backgroundColor: Colors.redAccent,
          );
          ScaffoldMessenger.of(context).showSnackBar(couponExists);
        } else {
          if (checkItemExists(cartList, itemInfo)) {
            SnackBar itemFree = SnackBar(
              content: Text(successText),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(itemFree);

            setState(() {
              isDiscount = true;
            });
          } else {
            setState(() {
              isDiscount = false;
            });

            SnackBar itemNotEligible = SnackBar(
              content: Text('This Item is not Eligible for the Offer'),
              backgroundColor: Colors.redAccent,
            );
            ScaffoldMessenger.of(context).showSnackBar(itemNotEligible);
          }
        }
      }

    }else if(couponSnapshot.data['type']=="delivery"){

      successText = couponSnapshot.data['successText'];

      setState(() {
        discountAmount = couponSnapshot.data['discountAmount'];
      });



      List itemInfo = couponSnapshot.data['itemList'];
      int items = couponSnapshot.data['items'];
      List<String> cartList =
      EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);

      if (items != cartList.length - 1) {
        setState(() {
          isDiscount = false;
        });

        SnackBar singleItem = SnackBar(
          content: Text('There can only be $items items in the cart'),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(singleItem);
      } else {

        if (isSubset(itemInfo, cartList.sublist(1), itemInfo.length, cartList.length -1 )) {
          SnackBar itemFree = SnackBar(
            content: Text(successText),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(itemFree);

          setState(() {
            isDiscount = true;
          });
        } else {
          setState(() {
            isDiscount = false;
          });

          SnackBar itemNotEligible = SnackBar(
            content: Text('This Item is not Eligible for the Offer'),
            backgroundColor: Colors.redAccent,
          );
          ScaffoldMessenger.of(context).showSnackBar(itemNotEligible);
        }
      }










































    }


  }

  checkItemExists(List array, String item) {
    return array.contains(item);
  }


  isSubset(List array1, List array2,
  int m, int n)
  {
  int i = 0;
  int j = 0;
  for (i = 0; i < n; i++) {
  for (j = 0; j < m; j++) {
  if (array2[i] == array1[j])
  break;
  }

  /* If the above inner loop was
        not broken at all then arr2[i]
        is not present in arr1[] */
  if (j == m)
  return false;
  }

  /* If we reach here then all
    elements of arr2[] are present
    in arr1[] */
  return true;
  }
}
