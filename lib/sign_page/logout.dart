import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartcar/global/common/toast.dart';
import 'package:smartcar/sign_page/login.dart';
import '../history.dart';
import '../map_screen.dart';
class Logout extends StatefulWidget{
  const Logout ({super.key});
  @override
  State<StatefulWidget> createState() => LogoutState();
}
//tao bien luu du lieu tu database ve
class LogoutState extends State<Logout>{
  int _selectedItem = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: const Center(
            child: Text('Log out', style: TextStyle(fontSize: 30,color: Colors.white),)
        ),
      ),
      bottomNavigationBar:
      Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: GNav(
              selectedIndex: _selectedItem,
              gap: 10,
              padding: EdgeInsets.all(10),
              onTabChange: (index){
                _onItemTapped(index,context);
              },
              backgroundColor: Colors.green,
              activeColor: Colors.white,
              color: Colors.white,
              tabBackgroundColor: Colors.green.shade300,
              tabs:[
                GButton(
                    icon: Icons.home,
                    text: "Home",
                ),
                GButton(
                    icon: Icons.history,
                    text: "History",
                ),
                GButton(
                    icon: Icons.logout,
                    text: "Log out",
                )
              ]
          ),
        ),
      ),
    );
  }
  void _onItemTapped (int index, BuildContext context){
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
                  FirebaseAuth.instance.signOut();
                  showToast(message: "Successfully signed out");
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