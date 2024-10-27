import 'package:flutter/material.dart';
import 'package:smartcar/common_page/lockscreen.dart';
import 'package:smartcar/global/common/toast.dart';
import 'package:smartcar/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcar/auth/auth.dart';
import 'package:smartcar/sign_page/login.dart';
class SignUpScreen extends StatefulWidget{
  const SignUpScreen ({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}
class _SignUpScreen extends State<SignUpScreen>{
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isSignUp = false; //bien nay de hien dau quay tron khi an signup
  bool _isShowOn = true;// bien nay de xem co hien password khong
  //hai bien nay de luu du lieu username va password
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // viet de tranh bo nho bi ro ri
  @override
  void dispose(){
    usernameController.dispose();
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
                controller: usernameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 19,color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 15),
                ),
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
                  _signUp();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child:_isSignUp ? CircularProgressIndicator(color: Colors.white,) : Text('SIGN UP',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
            ),
            SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyLoginScreen()));
                  },
                  child: Text("Sign In",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  void _signUp() async{
    setState(() {
      _isSignUp = true;
    });
    String username =usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password, username);
    setState(() {
      _isSignUp=false;
    });
    if(user!= null){
      showToast(message: "User is successfully created");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LockScreen()));
    }else{
      print( "An error occured");
    }

  }
}
