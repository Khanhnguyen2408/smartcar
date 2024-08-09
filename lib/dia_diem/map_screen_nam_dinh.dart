import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import '../map_screen.dart';
class MapScreen1 extends StatefulWidget {
  @override
  State<MapScreen1> createState() => _MapScreenState(); // tao bien state để lưu vị trí ban đầu local
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(21.0227384, 105.8163641),// kinh độ vĩ độ của thành phố đc chọn
      zoom: 8, //độ zoom ban đầu
  );
}
class _MapScreenState extends State<MapScreen1> {
  //phải viết lại hàm local của nó
  //những biến ban đầu của hàm
  late GoogleMapController mapController;
  double _originLatitude = 20.9802208, _originLongitude = 105.8389601;
  double _destLatitude = 20.4375965, _destLongitude = 106.1499026;
  double nowLatitude =0.0, nowLongitude = 0.0; // để lưu vị trí hiện tại
  final String _apiKey='AIzaSyAb_jZ05qokcR-U4RAYpwNeHJoXyRyBjYI';
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  //we read data on firebase
  //b1 khai bao bien lưu
  final database=FirebaseDatabase.instance.ref('vi tri');
  Future <void> fectchData() async{
    DatabaseEvent event =await database.once();
    final data = event.snapshot.value as Map<dynamic,dynamic>;
    setState(() {
      nowLatitude = _convertToDouble(data["latitude"]) ;
      nowLongitude = _convertToDouble(data["longtitude"]);
      addMarker(LatLng(nowLatitude, nowLongitude), "now",
          BitmapDescriptor.defaultMarkerWithHue(200));
    });
  }
  double _convertToDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      // Xử lý trường hợp giá trị không phải là một kiểu dữ liệu mong muốn
      print("Value is not a valid type for conversion to double.");
      return 0.0;
    }
  }
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }
  void addMarker(LatLng position, String id, BitmapDescriptor descriptor){
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    setState(() {
      markers[markerId] = marker;
    });

  }
  void addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
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
      addPolyLine();
    }
  }

  @override
  void initState() {
    super.initState();
    getPolypoints();
    fectchData();
    addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);
    addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                // myLocationButtonEnabled: false,
                initialCameraPosition: MapScreen1._initialCameraPosition,
                // lưu vị trí của nó vào vị trí ban đầu
                polylines: Set<Polyline>.of(polylines.values),
                onMapCreated: _onMapCreated,
                markers: markers.values.toSet(),
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(43, 174, 102, 1),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius:10
                    )
                  ]
                ),
                child: Center(
                  child: Text(
                    '1 giờ 50 phút',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom:10,
                left: 20,
                right: 20,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> order()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(43, 174, 102, 1),
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    child: Text(
                      'Đặt vé',
                      style: TextStyle(
                          color: Colors.white
                      ),

                    )
                )
            )
          ],
        )
    );
  }
}
class order extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return order2State();
  }
}
final databaseReference = FirebaseDatabase.instance.ref("Nam Dinh");
final databaseHis = FirebaseDatabase.instance.ref("His"); // để lưu những nhà xe đã đặt xe
class order2State extends State<order>{
  String? selectedItem1;
  String? selectedItem2;
  final TextEditingController quantity=TextEditingController();
  final  TextEditingController sdt=TextEditingController();
  bool _sdtInvl = false;
  var _sdtErr="Số điện thoại không hợp lệ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Đặt vé', style: TextStyle(fontSize: 30,color: Colors.white),)
      ),
      body: Column(
          children:[Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    hint: Text('Nhà xe'),
                    value: selectedItem1,
                    items: <String>['Việt Nam','Thái Học','Ninh Trang']
                        .map((String value){
                      return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedItem1=newValue;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    hint: Text('Giờ chạy'),
                    value: selectedItem2,
                    items: <String>['8h','13h','20h']
                        .map((String value){
                      return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedItem2=newValue;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                  child:Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: quantity,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 25
                      ),
                      decoration: InputDecoration(
                          labelText: 'Số lượng',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  )
              )
            ],
          ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
               controller: sdt,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontSize: 25
                ),
                decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    errorText: _sdtInvl ? _sdtErr : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            Container(
              child: Text('Giá tiền của chuyến đi là 150k/vé',style: TextStyle(fontSize: 20),),
            ),
            Container(
              child: Image(
                  image:AssetImage('assets/3e79f223d29370cd2982.jpg')
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: ElevatedButton(
                    onPressed: (){
                      //push data in firebase realtime database
                      final id = DateTime.now().millisecondsSinceEpoch.toString();
                      databaseReference.child(id).set({
                        'quantity':quantity.text.toString(),
                        'sdt':sdt.text.toString(),
                        'id':id,
                        'nha xe':selectedItem1.toString(),
                        'gio':selectedItem2.toString()
                      });
                      databaseHis.child(id).set({
                        'nha xe':selectedItem1.toString(),
                        'quantity': 'Nam Dinh'
                      });
                      onClick();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(43, 174, 102, 1),
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    child: Text('Hoàn thành',style: TextStyle(fontSize: 20,color: Colors.white,),)
                )
            )
          ]
      ),
    );
  }
  void onClick(){
    setState(() {
      if(sdt.text.length==10 && sdt.text.startsWith('0')){
        _sdtInvl = false;
      }else{
        _sdtInvl = true;
      }
      if(_sdtInvl==false){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()));
      }
    });
  }
}