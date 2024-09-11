import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartcar/sign_page/login.dart';
import 'package:smartcar/main.dart';
import 'history.dart';
class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState(); // tao bien state để lưu vị trí ban đầu local
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(21.0227384, 105.8163641),// kinh độ vĩ độ của thành phố đc chọn
      zoom: 8 //độ zoom ban đầu
  );
}
class _MapScreenState extends State<MapScreen> {
  //phải viết lại hàm local của nó
  //những biến ban đầu của hàm
  late GoogleMapController mapController;
  double _originLatitude = 20.9802208, _originLongitude = 105.8389601;
  double _destLatitude = 20.4375965, _destLongitude = 106.1499026;

  final String _apiKey='AIzaSyAb_jZ05qokcR-U4RAYpwNeHJoXyRyBjYI';
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }
  void getPolypoints() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _apiKey,
      request: PolylineRequest(
          origin: PointLatLng(_originLatitude, _originLongitude),
          destination: PointLatLng(_destLatitude, _destLongitude),
          mode: TravelMode.driving,
          wayPoints: [PolylineWayPoint(location: "khanh")]
      ),
    );

    if(result.points.isNotEmpty){
      result.points.forEach(
            (PointLatLng points) => polylineCoordinates.add(
            LatLng(points.latitude, points.longitude)
        ),
      );
    }
  }
  void addMarker(LatLng position, String id, BitmapDescriptor descriptor){
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    setState(() {
      markers[markerId] = marker;
    });

  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // đây là các biến lấy vị trí của người dùng
    late GoogleMapController googleMapController;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: const Center(
              child: Text('Smart Car', style: TextStyle(fontSize: 30,color: Colors.white),)
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                // myLocationButtonEnabled: false,
                initialCameraPosition: MapScreen._initialCameraPosition,
                // lưu vị trí của nó vào vị trí ban đầu
                onMapCreated: (GoogleMapController controller){
                  googleMapController=controller;
                },
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    Position position = await _determinePosition();
                    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude))));
                    addMarker(LatLng(position.latitude, position.longitude), "Current Location", BitmapDescriptor.defaultMarkerWithHue(90));
                    setState(() {});
                  },
                  label: Text("Current Location"),
                  icon: Icon(Icons.location_history),
                )
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: ElevatedButton.icon(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: CustomSearch()
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  icon: Icon(Icons.search, size: 30,),
                  label: Text('Tìm kiếm ở đây', style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(192, 192, 192, 0.5)),)
              ),
            )
          ],
        ),
       bottomNavigationBar:
        Container(
         color: Colors.green,
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
           child: GNav(
               // selectedIndex: _selectedIndex,
               gap: 10,
               padding: EdgeInsets.all(8),
               onTabChange: (index){
                 _onItemTapped(index,context);
               },
               backgroundColor: Colors.green,
               color: Colors.white,
               activeColor: Colors.white,
               tabBackgroundColor: Colors.green.shade300,
               tabs:[
                 GButton(
                   icon: Icons.home,
                   text: 'Home',
                 ),
                 GButton(
                   icon: Icons.history,
                   text: 'History',
                 ),
                 GButton(
                   icon: Icons.logout,
                   text: 'Log out',
                 ),
               ]
           ),
         ),
       ),
    );
  }
}
// ham de hien ra khi nhan Gnav
void _onItemTapped (int index,BuildContext context ){
  switch(index){
    case 0:
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>MapScreen())
      );
      break;
    case 1:
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>RealTimeCRUDEdatabase())
      );
      break;
    case 2:
      _showLogoutDialog(context);
      break;
  }
}

void _showLogoutDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn đăng xuất không '),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();// dong dialog
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>MapScreen())
                  );
                },
                child: Text('Hủy')
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>MyLoginScreen())
                  );
                },
                child: Text('Đăng xuất')
            )
          ],
        );
      }
  );
}
// hàm lấy vị trí hiện tại
Future<Position> _determinePosition() async{
  bool serviceEnable;
  LocationPermission permission;
  serviceEnable = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnable){
    return Future.error("Location services are disable");
  }
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      return Future.error('Location permission denied');
    }
  }
  if(permission == LocationPermission.deniedForever){
    return Future.error('Location permission are permantly denied');
  }
  Position position = await Geolocator.getCurrentPosition();
  return position;
}
