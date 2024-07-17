import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartcar/main.dart';
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
  Map<MarkerId, Marker> markers = {}; // hê
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

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                // myLocationButtonEnabled: false,
                initialCameraPosition: MapScreen._initialCameraPosition,
                // lưu vị trí của nó vào vị trí ban đầu
              ),
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
        )
    );
  }
}


