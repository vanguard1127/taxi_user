import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi_user/Components/ink_well_custom.dart';
import 'package:flutter_taxi_user/theme/style.dart';
import 'package:flutter_taxi_user/Components/validations.dart';
import 'phoneVerification.dart';
import 'package:flutter_taxi_user/utility/network/ApiHelper.dart';
import 'package:flutter_taxi_user/utility/network/Constants.dart' as Constants;
import 'package:flutter_taxi_user/database/userinfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool showpassword = true;

  final Firestore _db = Firestore.instance;
  submit() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      userinfo.phonenumber = phoneController.text;
      userinfo.password = passwordController.text;
      //code
      fetchAlbum();
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => PhoneVerification()));
    }
  }

  fetchAlbum() async {
    Map<String, dynamic> data = {
      "deviceId": fcmToken,
      "domain": userinfo.domain,
      "email": userinfo.email,
      "password": userinfo.password,
      "phoneNumber": userinfo.phonenumber,
      "role": userinfo.role,
      "website": userinfo.website,
    };

    ApiHelper.postRequest(Constants.BASE_URL_LOGIN, data).then((data) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => PhoneVerification()));
      userinfo.ids = data.data.ids;
      userinfo.email = data.data.email;
      if (!data.status) {
      } else {
        print(data.message);
        if (data.status) {}
      }
    }).catchError((err) {
      print(err);
    });
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = 'kni';
    //  FirebaseUser user = await _auth.currentUser();
    // Get the token for this device
    fcmToken = await fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: InkWellCustom(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Stack(children: <Widget>[
            Container(
              height: 250.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/icon/Layer_2.png"),
                      fit: BoxFit.cover)),
            ),
            new Padding(
                padding: EdgeInsets.fromLTRB(18.0, 150.0, 18.0, 0.0),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: new Column(
                      children: <Widget>[
                        new Container(
                            //padding: EdgeInsets.only(top: 100.0),
                            child: new Material(
                          borderRadius: BorderRadius.circular(7.0),
                          elevation: 5.0,
                          child: new Container(
                            width: MediaQuery.of(context).size.width - 20.0,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: new Form(
                                key: formKey,
                                child: new Container(
                                  padding: EdgeInsets.all(18.0),
                                  child: new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Login',
                                        style: heading35Black,
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextFormField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                              validator:
                                                  validations.validateMobile,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.phone,
                                                    color: blackColor,
                                                    size: 20.0,
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .clear_thick_circled,
                                                      color: greyColor2,
                                                    ),
                                                    onPressed: () {
                                                      phoneController.clear();
                                                    },
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0),
                                                  hintText: 'Phone',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'Quicksand'))),
                                          SizedBox(
                                            height: 20 * size.height / 760,
                                          ),
                                          TextFormField(
                                              controller: passwordController,
                                              keyboardType: TextInputType.phone,
                                              validator:
                                                  validations.validatePassword,
                                              obscureText: showpassword,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: blackColor,
                                                    size: 20.0,
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      showpassword
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: greyColor2,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        showpassword =
                                                            !showpassword;
                                                      });
                                                    },
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0),
                                                  hintText: 'Password',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'Quicksand'))),
                                        ],
                                      ),
                                      new ButtonTheme(
                                        height: 50.0,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        child: RaisedButton.icon(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0)),
                                          elevation: 0.0,
                                          color: primaryColor,
                                          icon: new Text(''),
                                          label: new Text(
                                            'NEXT',
                                            style: headingWhite,
                                          ),
                                          onPressed: () {
                                            submit();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )),
                        new Container(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  "Create new account? ",
                                  style: textGrey,
                                ),
                                new InkWell(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/signup2'),
                                  child: new Text(
                                    "Sign Up",
                                    style: textStyleActive,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ))),
          ])
        ]),
      )),
    );
  }
}
