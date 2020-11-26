import 'package:flutter/material.dart';
import 'package:flutter_taxi_user/Screen/Home/myActivity.dart';
import 'package:flutter_taxi_user/Screen/Request/requestDetail.dart';
import 'package:flutter_taxi_user/theme/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taxi_user/Screen/Menu/Menu.dart';
import 'package:flutter_taxi_user/data/Model/placeItem.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'radioSelectMapType.dart';
import 'package:flutter_taxi_user/data/Model/mapTypeModel.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import '../../Components/itemRequest.dart';
import '../../google_map_helper.dart';
import '../../data/Model/direction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_taxi_user/utility/network/Constants.dart' as Constants;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_taxi_user/database/triphistorydata.dart';
import 'package:flutter_taxi_user/database/userinfo.dart';
import 'package:flutter_taxi_user/utility/network/ApiHelper.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  TextEditingController sendtextController = TextEditingController();

  CircleId selectedCircle;
  GoogleMapController _mapController;

  String currentLocationName;
  String newLocationName;
  String _placemark = '';
  GoogleMapController mapController;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  bool checkPlatform = Platform.isIOS;
  double distance = 0;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;

  List<Routes> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  PolylineId selectedPolyline;
  bool isShowDefault = false;
  Position currentLocation;
  Position _lastKnownPosition;
  bool isEnabledLocation = false;

  final Geolocator _locationService = Geolocator();
  //PermissionStatus permission;

  @override
  void initState() {
    super.initState();
//    _initLastKnownLocation();
//    _initCurrentLocation();
    fetchLocation();
    showPersBottomSheetCallBack = _showBottomSheet;
    sampleData.add(MapTypeModel(1, true, 'assets/style/maptype_nomal.png',
        'Nomal', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2, false, 'assets/style/maptype_silver.png',
        'Silver', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3, false, 'assets/style/maptype_dark.png',
        'Dark', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4, false, 'assets/style/maptype_night.png',
        'Night', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5, false, 'assets/style/maptype_netro.png',
        'Netro', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6, false, 'assets/style/maptype_aubergine.png',
        'Aubergine', 'assets/style/aubergine_mode.json'));

    listRequest.add(new Map());
    listRequest[listRequest.length - 1] = {
      "id": requirenum.toString(),
      "avatar": "https://source.unsplash.com/1600x900/?portrait",
      "userName": "Olivia Nastya",
      "date": '08 Jan 2019 at 12:00 PM',
      "price": 152,
      "distance": "10km",
      "addFrom": "2536 Flying Taxicabs",
      "addTo": "2 William St, Chicago, US",
      "locationForm": LatLng(42.305444, -72.201658),
      "locationTo": LatLng(42.327784, -71.953803),
    };listRequest.add(new Map());
    listRequest[listRequest.length - 1] = {
      "id": requirenum.toString(),
      "avatar": "https://source.unsplash.com/1600x900/?portrait",
      "userName": "Olivia Nastya",
      "date": '08 Jan 2019 at 12:00 PM',
      "price": 152,
      "distance": "10km",
      "addFrom": "2536 Flying Taxicabs",
      "addTo": "2 William St, Chicago, US",
      "locationForm": LatLng(42.305444, -72.201658),
      "locationTo": LatLng(42.327784, -71.953803),
    };listRequest.add(new Map());
    listRequest[listRequest.length - 1] = {
      "id": requirenum.toString(),
      "avatar": "https://source.unsplash.com/1600x900/?portrait",
      "userName": "Olivia Nastya",
      "date": '08 Jan 2019 at 12:00 PM',
      "price": 152,
      "distance": "10km",
      "addFrom": "2536 Flying Taxicabs",
      "addTo": "2 William St, Chicago, US",
      "locationForm": LatLng(42.305444, -72.201658),
      "locationTo": LatLng(42.327784, -71.953803),
    };listRequest.add(new Map());
    listRequest[listRequest.length - 1] = {
      "id": requirenum.toString(),
      "avatar": "https://source.unsplash.com/1600x900/?portrait",
      "userName": "Olivia Nastya",
      "date": '08 Jan 2019 at 12:00 PM',
      "price": 152,
      "distance": "10km",
      "addFrom": "2536 Flying Taxicabs",
      "addTo": "2 William St, Chicago, US",
      "locationForm": LatLng(42.305444, -72.201658),
      "locationTo": LatLng(42.327784, -71.953803),
    };
    if (listRequest.length < 2) isShowDefault = true;
    notificationrecieve();
  }

  StreamSubscription iosSubscription;
  void notificationrecieve() {
    fcm.subscribeToTopic("driver_flutter_app");
    if (Platform.isIOS) {
      iosSubscription = fcm.onIosSettingsRegistered.listen((data) {
        print(data);
      });
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          tripid = message['data']['tripId'];
          listRequest.add(new Map());
          listRequest[listRequest.length - 1] = {
            "id": '2',
            "avatar": "https://source.unsplash.com/1600x900/?portrait",
            "userName": "Olivia Nastya",
            "date": '08 Jan 2019 at 12:00 PM',
            "price": 152,
            "distance": message['data']['km'],
            "addFrom": "2536 Flying Taxicabs",
            "addTo": "2 William St, Chicago, US",
            "locationForm": LatLng(42.305444, -72.201658),
            "locationTo": LatLng(42.327784, -71.953803),
          };
        });
        if (listRequest.length > 1) isShowDefault = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Text(message['notification']['body']),
                      Text("source : " + message['data']['source']),
                      Text("dest : " + message['data']['dest']),
                      Text("km : " + message['data']['km']),
                    ],
                  )),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.green,
                  child: Text("Accept"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  color: Colors.red,
                  child: Text("reject"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: ListTile(
                          title: Text("reason"),
                          subtitle: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextField(
                                maxLines: 5,
                                controller: sendtextController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              color: Colors.red,
                              child: Text("Send"),
                              onPressed: () {
                                Map<String, dynamic> data = {
                                  "deviceId": fcmToken,
                                  "ids": userinfo.ids,
                                  "status": "REJECT",
                                  "tripId": tripid,
                                };
                                ApiHelper.putRequest(
                                    Constants.BASE_URL +
                                        Constants.BASE_URL_ACCEPT,
                                    data);
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  //sendacceptmessage
  void sendaccept() {
    Map<String, dynamic> data = {
      "deviceId": fcmToken,
      "ids": userinfo.ids,
      "status": "ACCEPT",
      "tripId": tripid,
    };
    ApiHelper.putRequest(Constants.BASE_URL + Constants.BASE_URL_ACCEPT, data);
  }

  //sendrejectmessage
  void sendreject() {
    Map<String, dynamic> data = {
      "deviceId": fcmToken,
      "ids": userinfo.ids,
      "status": "REJECT",
      "tripId": tripid,
    };
    ApiHelper.putRequest(Constants.BASE_URL + Constants.BASE_URL_ACCEPT, data);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkPermission() async {
    isEnabledLocation = await Permission.location.serviceStatus.isEnabled;
  }

  void fetchLocation() {
    _initCurrentLocation();
    checkPermission()?.then((_) {
      if (isEnabledLocation) {
        _initCurrentLocation();
      }
    });
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator?.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _lastKnownPosition = position;
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    List<Placemark> placemarks =
        await _locationService.placemarkFromCoordinates(
            currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.name + ', ' + pos.thoroughfare;
        print(_placemark);
        currentLocationName = _placemark;
      });
    }
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 17.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    this._mapController = controller;
    addMarker(listRequest[0]['locationForm'], listRequest[0]['locationTo']);
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName) {
    print(fileName);
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName).then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = await _scaffoldKey.currentState.showBottomSheet((context) {
      return new Container(
          height: 300.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Map type",
                        style: heading18Black,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: blackColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: new GridView.builder(
                    itemCount: sampleData.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        highlightColor: primaryColor,
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          _closeModalBottomSheet();
                          sampleData
                              .forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                          changeMapType(
                              sampleData[index].id, sampleData[index].fileName);
                        },
                        child: new MapTypeItem(sampleData[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }

  void _closeModalBottomSheet() {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  addMarker(LatLng locationForm, LatLng locationTo) {
    _markers.clear();
    final MarkerId _markerFrom = MarkerId("fromLocation");
    final MarkerId _markerTo = MarkerId("toLocation");
    _markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: "fromLocation",
      icon: checkPlatform
          ? "assets/image/gps_point_24.png"
          : "assets/image/gps_point.png",
      lat: locationForm.latitude,
      lng: locationForm.longitude,
    );

    _markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: "toLocation",
      icon: checkPlatform
          ? "assets/image/ic_marker_32.png"
          : "assets/image/ic_marker_128.png",
      lat: locationTo.latitude,
      lng: locationTo.longitude,
    );
    _gMapViewHelper?.cameraMove(
        fromLocation: locationForm,
        toLocation: locationTo,
        mapController: _mapController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new MenuScreens(activeScreenName: screenName),
      body: Container(
        color: whiteColor,
        child: Stack(
          children: <Widget>[
            _buildMapLayer(),
            Positioned(
                bottom: isShowDefault == false ? 330 : 250,
                right: 16,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.my_location,
                      size: 20.0,
                      color: blackColor,
                    ),
                    onPressed: () {
                      _initCurrentLocation();
                    },
                  ),
                )),
            Positioned(
                top: 50,
                right: 10,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.layers,
                      size: 20.0,
                      color: blackColor,
                    ),
                    onPressed: () {
                      _showBottomSheet();
                    },
                  ),
                )),
            Positioned(
                top: 50,
                left: 10,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 20.0,
                      color: blackColor,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: isShowDefault == false
                  ? Container(
                      height: 330,
                      child: TinderSwapCard(
                          orientation: AmassOrientation.TOP,
                          totalNum: listRequest.length,
                          stackNum: listRequest.length,
                          maxWidth: MediaQuery.of(context).size.width,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          maxHeight: MediaQuery.of(context).size.width * 0.9,
                          minHeight: MediaQuery.of(context).size.width * 0.85,
                          cardBuilder: (context, index) => ItemRequest(
                                avatar: listRequest[index]['avatar'],
                                userName: listRequest[index]['id'],
                                date: listRequest[index]['date'],
                                price: listRequest[index]['price'].toString(),
                                distance: listRequest[index]['distance'],
                                addFrom: listRequest[index]['addFrom'],
                                addTo: listRequest[index]['addTo'],
                                locationForm: listRequest[index]
                                    ['locationForm'],
                                locationTo: listRequest[index]['locationTo'],
                                onTap: () {
                                  setState(() {
                                    sendaccept();
                                    listRequest.removeAt(0);
                                    if (index == listRequest.length - 1) {
                                      setState(() {
                                        isShowDefault = true;
                                      });
                                    } else {
                                      addMarker(
                                          listRequest[index + 1]
                                              ['locationForm'],
                                          listRequest[index + 1]['locationTo']);
                                    }
                                  });
                                  //Navigator.of(context).push(MaterialPageRoute(
                                  //builder: (context) => RequestDetail()));
                                },
                                onTap1: () {
                                  setState(() {
                                    sendreject();
                                    listRequest.removeAt(0);
                                    if (index == listRequest.length - 1) {
                                      setState(() {
                                        isShowDefault = true;
                                      });
                                    }
                                  });
                                },
                              ),
                          swipeUpdateCallback:
                              (DragUpdateDetails details, Alignment align) {
                            /// Get swiping card's position
                          },
                          swipeCompleteCallback:
                              (CardSwipeOrientation orientation, int index) {
                            /// Get orientation & index of swiped card!
                            print('index $index');
                            print('aaa ${listRequest.length}');
                            if (orientation == CardSwipeOrientation.LEFT)
                              sendaccept();
                            if (orientation == CardSwipeOrientation.RIGHT)
                              sendreject();
                            listRequest.removeAt(0);
                            setState(() {
                              if (index == listRequest.length - 1) {
                                setState(() {
                                  isShowDefault = true;
                                });
                              } else {
                                addMarker(
                                    listRequest[index + 1]['locationForm'],
                                    listRequest[index + 1]['locationTo']);
                              }
                            });
                          }),
                    )
                  : listRequest.length > 0
                      ? Container(
                          height: 330,
                          child: ItemRequest(
                            avatar: listRequest[0]['avatar'],
                            userName: listRequest[0]['id'],
                            date: listRequest[0]['date'],
                            price: listRequest[0]['price'].toString(),
                            distance: listRequest[0]['distance'],
                            addFrom: listRequest[0]['addFrom'],
                            addTo: listRequest[0]['addTo'],
                            locationForm: listRequest[0]['locationForm'],
                            locationTo: listRequest[0]['locationTo'],
                            onTap: () {
                              setState(() {
                                sendaccept();
                                listRequest.removeAt(0);
                                setState(() {
                                  isShowDefault = true;
                                });
                              });
                              //Navigator.of(context).push(MaterialPageRoute(
                              //builder: (context) => RequestDetail()));
                            },
                            onTap1: () {
                              setState(() {
                                sendreject();
                                listRequest.removeAt(0);
                                setState(() {
                                  isShowDefault = true;
                                });
                              });
                            },
                          ),
                        )
                      : MyActivity(
                          userImage:
                              'https://source.unsplash.com/1600x900/?portrait',
                          userName: 'Nemi Chand',
                          level: 'Bassic level',
                          totalEarned: '\$250',
                          hoursOnline: 10.5,
                          totalDistance: '22Km',
                          totalJob: 8,
                        ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMapLayer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _gMapViewHelper.buildMapView(
          context: context,
          onMapCreated: _onMapCreated,
          currentLocation: LatLng(
              currentLocation != null
                  ? currentLocation?.latitude
                  : _lastKnownPosition?.latitude ?? 0.0,
              currentLocation != null
                  ? currentLocation?.longitude
                  : _lastKnownPosition?.longitude ?? 0.0),
          markers: _markers,
          polyLines: _polyLines,
          onTap: (_) {}),
    );
  }
}
