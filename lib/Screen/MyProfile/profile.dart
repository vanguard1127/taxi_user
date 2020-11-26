import 'package:flutter/material.dart';
import 'package:flutter_taxi_user/Screen/MyProfile/myProfile.dart';
import '../../theme/style.dart';
import 'chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_taxi_user/database/userinfo.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return MyProfile();
                },
              ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Column(
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                              child: imagefile == null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          "https://source.unsplash.com/1600x900/?portrait",
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      imagefile,
                                      fit: BoxFit.fill,
                                      height: 150.0,
                                      width: 150.0,
                                    ),
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      height: 15.0,
                      width: 15.0,
                      child: Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenColor,
                            border:
                                Border.all(color: Colors.white, width: 2.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Mr " + userinfo.firstname + " " + userinfo.lastname,
                      style: TextStyle(color: blackColor, fontSize: 35.0),
                    ),
                    Text(
                      "Client since 2016",
                      style: TextStyle(color: blackColor, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: whiteColor,
                child: LineChartWallet(),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: backgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: textStyle,
                          ),
                          Text(
                            "Mr " +
                                userinfo.firstname +
                                " " +
                                userinfo.lastname,
                            style: textGrey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: backgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Phone Number',
                            style: textStyle,
                          ),
                          Text(
                            userinfo.phonenumber,
                            style: textGrey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: backgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: textStyle,
                          ),
                          Text(
                            userinfo.email,
                            style: textGrey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: backgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Birthday',
                            style: textStyle,
                          ),
                          Text(
                            DateFormat.yMMMMd().format(userinfo.birthday),
                            style: textGrey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
