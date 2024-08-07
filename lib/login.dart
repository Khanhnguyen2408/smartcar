import 'package:flutter/material.dart';
import 'package:smartcar/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
class MyLoginScreen extends StatefulWidget{
  const MyLoginScreen ({super.key});
  @override
  State<MyLoginScreen> createState() => _MyLoginScreen();
}
class _MyLoginScreen extends State<MyLoginScreen>{
  bool _isShowOn = true;
  //hai bien nay de luu du lieu username va password
  final TextEditingController username =new TextEditingController();
  final TextEditingController password =new TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref("Login"); // tao bien tham chieu truyen len firebase realtime database
  var _usernameErr = "Tai khoản khong hợp le";
  var _passwordErr = "Mat khau khong hop le ";
  var _userInvl = false;
  var _passInvl = false;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
             child: Text('Hello\nWelcome back',
               style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 20),
             child: TextField(
               controller: username,
               keyboardType: TextInputType.text,
               style: TextStyle(fontSize: 19,color: Colors.black),
               decoration: InputDecoration(
                   labelText: 'USERNAME',
                   labelStyle: TextStyle(color: Colors.grey,fontSize: 15),
                   errorText: _userInvl ? _usernameErr : null
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 40),
             child: Stack(
                 alignment: AlignmentDirectional.centerEnd,
                 children:[
                   TextField(
                     controller: password,
                     keyboardType: TextInputType.text,
                     style: TextStyle(fontSize: 19,color: Colors.black),
                     obscureText: _isShowOn,
                     decoration: InputDecoration(
                         labelText: 'PASSWORD',
                         labelStyle: TextStyle(color: Colors.grey,fontSize: 15),
                         errorText: _passInvl ? _passwordErr : null
                     ),
                   ),
                   GestureDetector(// giup bat tat show password
                       onTap: (){
                         setState(() {
                           _isShowOn =! _isShowOn; // khi nhan no doi sang cai khac
                         });
                       },
                       child: Text(_isShowOn?'SHOW':'HIDE' ,style: TextStyle(fontSize: 13,color: Colors.green,fontWeight: FontWeight.bold),)
                   )
                 ]
             ),
           ),
           SizedBox(
             width: double.infinity,
             height: 56,
             child: ElevatedButton(
                onPressed: (){
                  onClicked();
                },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.green,
                   padding: EdgeInsets.all(15),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20)
                   )
                 ),
               child: Text('SIGN IN',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
             ),
           ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Notes: username is phone number and password is email',style: TextStyle(fontSize: 15,color: Colors.grey),),
          )
         ],
       ),
     ),
   );
  }
  //khi nguoi dung an vao sign in
  void onClicked(){
    setState(() {
      if(username.text.length==10 && username.text.startsWith('0')){
        _userInvl = false;
      }else{
        _userInvl = true;
      }
      if(password.text.contains('@')){
        _passInvl = false;
      }else{
        _passInvl = true;
      }
      if(_userInvl==false && _passInvl==false){
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        databaseReference.child(id).set({
          'SDT':username.text.toString(),
          'email':password.text.toString()
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()));
      }
    });
  }
}
