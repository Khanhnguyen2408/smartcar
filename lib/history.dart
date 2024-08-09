import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartcar/login.dart';
import 'map_screen.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
      title: const Center(
          child: Text('History', style: TextStyle(fontSize: 30,color: Colors.white),)
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
      bottomNavigationBar:
      Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: GNav(
              selectedIndex: _selectedIndex,
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
                  text: 'Log Out',
                ),
              ]
          ),
        ),
      ),
    );
  }
}
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
                  Navigator.of(context).pop(); // dong dialog
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

