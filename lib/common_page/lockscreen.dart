import 'package:flutter/material.dart';
import 'map_screen.dart';
class LockScreen extends StatelessWidget{
  const LockScreen({super.key});
  Widget renderSpace(BuildContext context){
    return Container(
      height: 450,
      width: double.infinity,
      child: SizedBox(),
    );
  }
  Widget renderButton (BuildContext context){
    return ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(43, 174, 102, 1),
            padding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )
        ),
        child: Text('Bắt đầu',style: TextStyle(fontSize: 20,color: Colors.white,),)
    );
  }
  Widget renderBody(BuildContext context){
    return Expanded(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text("Được phát triển bởi: ", style: TextStyle(color: Colors.black,fontSize: 20),),
              ),
              Container(
                width: 70,
                height: 70,
                child: Image(
                    image: AssetImage('assets/LogoPTIT.png'),
                  fit: BoxFit.fill,
                )
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text("Xin chào", style: TextStyle(color: Colors.black,fontSize: 50,fontWeight: FontWeight.bold),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text("Phục vụ với trái tim và tâm huyết",style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
              renderButton(context),
            ],
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: Color(0XFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/hinhnen.jpg"),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Column(
                      children: [
                        renderSpace(context),
                        renderBody(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

}