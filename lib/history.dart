import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'global/common/navigationdrawer.dart';
// lấy dữ liệu từ trên firebase để hiện lên trên thành list
class RealTimeCRUDEdatabase extends StatefulWidget {
  const RealTimeCRUDEdatabase({super.key});
  @override
  State<RealTimeCRUDEdatabase> createState() => _RealTimeDatabaseState();
}
//tao bien luu du lieu tu database ve
final databaseReference = FirebaseDatabase.instance.ref("His");
class _RealTimeDatabaseState extends State<RealTimeCRUDEdatabase>{
  int _selectedIndex =1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      drawer: NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
        title: Text('History', style: TextStyle(fontSize: 30,color: Colors.white),),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Mở Drawer thủ công
            },
          ),
        ),
      ),
      body: Column(children: [
      // now we read data in realtime database
         Expanded(child:FirebaseAnimatedList(
               query: databaseReference,
               itemBuilder: (context, snapshot, animation, index){
                 return Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20),
                   ),
                   margin: EdgeInsets.all(10),
                   child: ListTile(
                     contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                     leading: CircleAvatar(
                       child: Text(
                           (index+1).toString(),
                       ),
                     ),
                     title: Text(
                       snapshot.child("nha xe").value.toString(),
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 22,
                       ),
                     ),
                     subtitle: Text(
                       snapshot.child("quantity").value.toString(),
                       style: TextStyle(fontSize: 10),
                     ),
                   ),
                 );
               }
              ),
         ),
      ],
      ),
    );
  }
}
