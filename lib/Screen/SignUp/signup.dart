import 'package:flutter/material.dart';
import 'package:flutter_taxi_user/Components/ink_well_custom.dart';
import 'package:flutter_taxi_user/theme/style.dart';
import 'package:flutter_taxi_user/Screen/Home/home.dart';
import 'package:flutter_taxi_user/Components/validations.dart';
import 'package:flutter_taxi_user/utility/network/ApiHelper.dart';
import 'package:flutter_taxi_user/utility/network/Constants.dart' as Constants;
import 'package:flutter_taxi_user/database/userinfo.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations = new Validations();

  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

fetchAlbum() async {
    Map<String, dynamic> data = {
      "category": userinfo.category,
      "deviceId": fcmToken,
      "domain": userinfo.domain,
      "email": userinfo.email,
      "firstName": userinfo.firstname,
      "Lastname": userinfo.lastname,
      "latituse": "0",
      "longitude": "0",
      "password": userinfo.password,
      "phoneNumber": userinfo.phonenumber,
      "role": userinfo.role,
      "website": userinfo.website,
      "latitude": userinfo.latitude,
      // ignore: equal_keys_in_map
      "longitude": userinfo.longitude
    };

    ApiHelper.postRequest(Constants.BASE_URL_LOGIN, data).then((data) {
      if (!data.status) {
      } else {
        print(data.message);
        if (data.status) {}
      }
    }).catchError((err) {
      print(err);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/image/icon/Layer_2.png"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 100.0, 18.0, 0.0),
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
                                        height: MediaQuery.of(context).size.height *0.65,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: new Form(
                                            child: new Container(
                                              padding: EdgeInsets.all(18.0),
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: 100.0,
                                                    width: 300.0,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text('Sign up', style: heading35Black,),
//                                                        Text(' with email and phone number', style: heading35BlackNormal,),
                                                      ],
                                                    ),
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.emailAddress,
                                                          validator: validations.validateEmail,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            prefixIcon: Icon(Icons.email,
                                                                color: blackColor, size: 20.0),
                                                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                            hintText: 'Email',
                                                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                          )
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 20.0),
                                                      ),
                                                      TextFormField(
                                                          keyboardType: TextInputType.phone,
                                                          validator: validations.validateMobile,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              prefixIcon: Icon(Icons.phone,
                                                                  color: blackColor, size: 20.0),
                                                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                              hintText: 'Phone',
                                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  new Container(
                                                    padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            child: new Text("Forgot Password ?",style: textStyleActive,),
                                                          ),
                                                        ],
                                                      )

                                                  ),
                                                  new ButtonTheme(
                                                    height: 50.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                                      elevation: 0.0,
                                                      color: primaryColor,
                                                      icon: new Text(''),
                                                      label: new Text('SIGN UP', style: headingWhite,),
                                                      onPressed: (){Navigator.of(context).pushReplacement(
                                                          new MaterialPageRoute(builder: (context) => new HomeScreen()));},
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("Already have an account? ",style: textGrey,),
                                        new InkWell(
                                          onTap: () => Navigator.pushNamed(context, '/login'),
                                          child: new Text("Login",style: textStyleActive,),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        )
                    ),
                  ]
                  )
                ]
            ),
          )

      ),
    );
  }
}
