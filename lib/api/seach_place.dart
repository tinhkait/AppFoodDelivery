import 'package:app_food_2023/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';

// ignore: implementation_imports, unused_import
import 'package:app_food_2023/api/google_map/src/google_map_place_picker.dart'; // do not import this yourself
import 'dart:io' show Platform;

// Your api key storage.
import 'package:app_food_2023/api/google_map/keys.dart';

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address {
  String address;
  double latitude;
  double longitude;
  DateTime dateTime;

  Address(this.address, this.latitude, this.longitude, this.dateTime);
}

class RecentAddresses {
  List<Address> _addresses = [];

  void addAddress(Address address) {
    _addresses.add(address);
  }

  List<Address> get addresses {
    // Sắp xếp các địa chỉ theo thời gian gần nhất đến xa nhất
    _addresses.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _addresses;
  }
}

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(10.8231, 106.6297);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

  late GoogleMapController mapController;
  late String searchAddress;

  List<String> recentAddresses = [""];
  List<String> myAddresses = [
    'Nhà',
    'Công Ty',
    'Thêm địa chỉ...',
  ];

  List<IconData> myAddressIcons = [
    Icons.home_outlined,
    Icons.work_outline,
    Icons.add_outlined,
  ];

  @override
  void initState() {
    super.initState();

    // Lấy danh sách địa chỉ từ Local Storage
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        recentAddresses = prefs.getStringList("recentAddresses") ?? [];
      });
    });
  }

  void addRecentAddress(String address) {
    recentAddresses.insert(0, address); // thêm vào đầu danh sách
    if (recentAddresses.length > 10) {
      // giới hạn danh sách chỉ có tối đa 10 địa chỉ gần đây
      recentAddresses.removeLast(); // xóa phần tử cuối danh sách
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Nhập địa chỉ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppHomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Nhập địa điểm hiện tại của bạn',
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search_outlined),
                          onPressed: () {},
                        ),
                      ),
                      onChanged: (value) {
                        searchAddress = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.map_outlined),
                    onPressed: () {
                      initRenderer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              resizeToAvoidBottomInset:
                                  false, // only works in page mode, less flickery
                              apiKey: Platform.isAndroid
                                  ? APIKeys.androidApiKey
                                  : APIKeys.iosApiKey,
                              hintText: "Find a place ...",
                              searchingText: "Please wait ...",
                              selectText: "Select place",
                              outsideOfPickAreaText: "Place not in area",
                              initialPosition: AddressPage.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              usePinPointingSearch: true,
                              usePlaceDetailSearch: true,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                print("Map created");
                              },
                              onPlacePicked: (PickResult result) {
                                print(
                                    "Place picked: ${result.formattedAddress}");
                                setState(() {
                                  setState(() {
                                    selectedPlace = result;

                                    // Thêm địa chỉ mới vào đầu danh sách recentAddresses
                                    recentAddresses.insert(
                                        0, result.formattedAddress!);
                                    print(result.formattedAddress!);
                                    // Lưu danh sách địa chỉ vào Local Storage
                                    SharedPreferences.getInstance()
                                        .then((prefs) {
                                      prefs.setStringList(
                                          "recentAddresses", recentAddresses);
                                    });

                                    Navigator.of(context).pop();
                                  });
                                });
                              },

                              onMapTypeChanged: (MapType mapType) {
                                print(
                                    "Map type changed to ${mapType.toString()}");
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(),
            if (selectedPlace != null) ...[
              Text(selectedPlace!.formattedAddress!),
              Text("(lat: " +
                  selectedPlace!.geometry!.location.lat.toString() +
                  ", lng: " +
                  selectedPlace!.geometry!.location.lng.toString() +
                  ")"),
            ],
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Địa điểm của tôi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: myAddresses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(myAddressIcons[index]),
                        title: Row(
                          children: [
                            Text(myAddresses[index]),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Địa điểm gần đây',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        'Xoá',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 134, 134, 134)),
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('recentAddresses');
                          prefs.remove('diachiHienTai');
                          setState(() {
                            recentAddresses = [];
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recentAddresses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          print(recentAddresses[index]);
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString(
                                "diachiHienTai", recentAddresses[index]);
                          });
                        },
                        leading: Icon(Icons.history),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(recentAddresses[index]),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchAddressOnMap() {
    // TODO: Implement map search functionality
  }
}
