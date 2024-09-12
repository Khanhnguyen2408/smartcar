import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartcar/auth/auth.dart';
import 'package:smartcar/map_screen.dart';
import '../../history.dart';
import '../../sign_page/login.dart';
class NavBar extends StatefulWidget{
  @override
  State<NavBar> createState()=> _NavBarState();

}

class _NavBarState extends State<NavBar>{
  String? _username; // de luu username
  String? _email;
  @override
  void initState(){
    _loadUsername();// ham user name de lay thong tin user hien tai

  }
  // ham lay thong tin nguoi dung
  void _loadUsername(){
// su dung firebase auth der lay thong tin user hien tai
    User? user =FirebaseAuthService().getCurrentUser();
    if(user!=null){
      setState(() {
        _username =user.displayName ?? "Unknow User";
        _email =user.email ?? "No Email";
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
  Widget buildHeader(BuildContext context)=> Container(
    color: Colors.green[300],
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 52,
          backgroundImage: NetworkImage(
              "https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg"
          ),
        ),
        Text("$_username", style: TextStyle(fontSize: 28,color: Colors.white),),
        Text("$_email", style: TextStyle(fontSize: 14,color: Colors.white),),
        SizedBox(height: 12,)
      ],
    ),
  );
  Widget buildMenuItems(BuildContext context)=> Container(
    padding: EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: Text("Home"),
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MapScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: Text("History"),
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>RealTimeCRUDEdatabase()));
          },
        ),
        const Divider(color: Colors.black54,),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text("Log Out"),
          onTap: (){
            _showLogoutDialog(context);
          },
        ),
      ],
    ),
  );
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
