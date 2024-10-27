import 'package:flutter/material.dart';
import '../global/common/navigationdrawer.dart';
class Information extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.green[100],
        drawer: NavBar(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: Text('Lịch sử', style: TextStyle(fontSize: 30,color: Colors.white),),
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
        body: SafeArea(
            child: Container(
              constraints: BoxConstraints.expand(),
              color: Colors.green[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                      child: Text(
                          "Đây là ứng dụng được phát triển bới Nhóm 2 IOT lab của Học Viện Công Nghệ Bưu Chính Viễn Thông",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20 ,)),
                      ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                             "Hướng dẫn",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontSize: 50,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                      child: Text(
                          "Vị trí màu đỏ là vị trí của bạn cần đón, vị trí điểm đến được in trên bản đồ màu xanh lá. Cuối cùng vị trí màu xanh nước chính là vị trí của xe.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child:Center(
                      child: Text(
                          "Cảm ơn đã sử dụng ứng dụng",
                          style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold)),
                    )
                  ),
                ],
              ),
            )
        ),
      );
  }

}