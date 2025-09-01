import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Config/config.dart';
import 'Store/storehome.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  User _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code = 0;
  int f;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
    f = 0;
  }

  void _handleError(e) {
    print(e.message);
    setState(() {
      _status += e.message + '\n';
    });
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      _status =
          (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
    });
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
        checkUser(_firebaseUser);
      }).catchError((e) => _handleError(e));
      setState(() {
        _status += 'Signed In\n';
      });
      // saveUserInfoToFireStore(_firebaseUser);
      // Route route = MaterialPageRoute(builder: (_) => StoreHome());
      // Navigator.pushReplacement(context, route);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid OTP",
          backgroundColor: Colors.black,
          textColor: Colors.white);

      _handleError(e);
    }
  }

  checkUser(User fUser) {
    FirebaseFirestore.instance
        .collection("users")
        .where("phonenumber", isEqualTo: fUser.phoneNumber)
        .getDocuments()
        .then((snapshot) {
      // snapshot.documents.forEach((result) {
      //   if (result.data["phonenumber"] == fUser.phoneNumber) {
      //     print(result.data["phonenumber"]);
      //     print(fUser.phoneNumber);

      //   }
      // });
      if (snapshot.documents.isEmpty) {
        saveUserInfoToFireStore(fUser);
      }
      if (snapshot.documents.isNotEmpty) {
        saveUserInfoToSharedPreferences(fUser);
      }
    });
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "phonenumber": fUser.phoneNumber,
      "isAdmin": "0",
      "couponHistory": [],

      // "name": _nameTextEditingController.text.trim(),
      // "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"]
    });

    await EcommerceApp.sharedPreferences!.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.phoneNumber, fUser.phoneNumber);

    await EcommerceApp.sharedPreferences!.setString("isAdmin", "0");
    // await EcommerceApp.sharedPreferences!.setString(
    //     EcommerceApp.userName, _nameTextEditingController.text.trim());
    // await EcommerceApp.sharedPreferences
    //     .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);

    Route route = MaterialPageRoute(builder: (_) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future saveUserInfoToSharedPreferences(User fUser) async {
    // print(f);
    // FirebaseFirestore.instance.collection("users").doc(fUser.uid).get()
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(fUser.uid).get();

    await EcommerceApp.sharedPreferences!.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.phoneNumber, fUser.phoneNumber);

    print(variable['isAdmin']);

    await EcommerceApp.sharedPreferences
        .setString("isAdmin", variable['isAdmin']);

    // await EcommerceApp.sharedPreferences!.setString(
    //     EcommerceApp.userName, _nameTextEditingController.text.trim());
    // await EcommerceApp.sharedPreferences
    //     .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);

    Route route = MaterialPageRoute(builder: (_) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  // Future<void> _logout() async {
  //   /// Method to Logout the `User` (`_firebaseUser`)
  //   try {
  //     // signout code
  //     await FirebaseAuth.instance.signOut();
  //     _firebaseUser = null;
  //     setState(() {
  //       _status += 'Signed out\n';
  //     });
  //   } catch (e) {
  //     _handleError(e);
  //   }
  // }

  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();

    String isAdmin = "0";
    // print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      // print('verificationCompleted');
      Fluttertoast.showToast(
          msg: "Verified Successfully",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      // print(phoneAuthCredential);
      _login();
    }

    void verificationFailed(AuthException error) {
      // print('verificationFailed');
      Fluttertoast.showToast(
          msg: "Verification Failed",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      _handleError(error);
    }

    void codeSent(String verificationId, [int code]) {
      // print('codeSent');
      Fluttertoast.showToast(
          msg: "OTP Sent",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      this._verificationId = verificationId;
      // print(verificationId);
      this._code = code;
      // print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      Fluttertoast.showToast(
          msg: "Time Out Resend OTP",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      // print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() {
    /// get the `smsCode` from the user
    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);

    _login();
  }

  void _reset() {
    _phoneNumberController.clear();
    _otpController.clear();
    setState(() {
      _status = "";
    });
  }

  // void _displayUser() {
  //   setState(() {
  //     _status += _firebaseUser.toString() + '\n';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow[300],
      // appBar: AppBar(
      //   actions: [
      //     GestureDetector(
      //       child: Icon(Icons.refresh),
      //       onTap: _reset,
      //     ),
      //   ],
      // ),
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.yellow[300],

          // image: DecorationImage(
          //   image: AssetImage("assets/login-background.jpg"),
          //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
          //   fit: BoxFit.cover,
          // ),
        ),

        child: ListView(
          padding: EdgeInsets.all(16),
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 120),
            Image.asset(
              "assets/podili_icon.png",
              width: 200,
              height: 200,
            ),
            // SizedBox(
            //   height: 20.0,
            // ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 7,
                  right: MediaQuery.of(context).size.width / 7,
                  top: 10,
                  bottom: 50),
              child: Text(
                "Welcome to Podili All in One",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width / 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
            SizedBox(height: 70),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,

                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: _submitPhoneNumber,
                    child: Text(
                      'Verify',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            _code != 0
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            hintText: 'OTP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          onPressed: _submitPhoneNumber,
                          child: Text(
                            'Resend',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 28),
            // Text('$_status'),
            MaterialButton(
              height: 50,
              onPressed: _submitOTP,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Icon(
                Icons.refresh,
                size: 40,
              ),
              onTap: _reset,
            ),
          ],
        ),
      ),
    );
  }
}
