import 'package:flutter/material.dart';
import 'package:smartcar/global/common/toast.dart';
import 'package:smartcar/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcar/auth/auth.dart';
import 'package:smartcar/sign_page/signup.dart';

import '../main.dart';
class MyLoginScreen extends StatefulWidget{
  const MyLoginScreen ({super.key});
  @override
  State<MyLoginScreen> createState() => _MyLoginScreen();
}
class _MyLoginScreen extends State<MyLoginScreen>{
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isLogin = false; // bien nay de xuat hien vòng tron khi nhan login
  bool _isShowOn = true;// bien nay de xem co hien password khong
  //hai bien nay de luu du lieu username va password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
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
               controller: emailController,
               keyboardType: TextInputType.text,
               style: TextStyle(fontSize: 19,color: Colors.black),
               decoration: InputDecoration(
                   labelText: 'EMAIL',
                   labelStyle: TextStyle(color: Colors.grey,fontSize: 15),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 40),
             child: Stack(
                 alignment: AlignmentDirectional.centerEnd,
                 children:[
                   TextField(
                     controller: passwordController,
                     keyboardType: TextInputType.text,
                     style: TextStyle(fontSize: 19,color: Colors.black),
                     obscureText: _isShowOn,
                     decoration: InputDecoration(
                         labelText: 'PASSWORD',
                         labelStyle: TextStyle(color: Colors.grey,fontSize: 15),
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
                  _signIn();
                },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.green,
                   padding: EdgeInsets.all(15),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20)
                   )
                 ),
               child: _isLogin ? CircularProgressIndicator(color: Colors.white,) : Text('SIGN IN',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
             ),
           ),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?"),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                },
                child: Text("Sign Up",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              )
            ],
          )
         ],
       ),
     ),
   );
  }
  void _signIn() async{
    setState(() {
      _isLogin = true;
    });
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      _isLogin=false;
    });
    if(user!= null){
      showToast(message: "User is successfully Sign In");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }else{
      print('An error occured');
    }
  }
}
