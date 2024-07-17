import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartcar/dia_diem/map_screen_thai_nguyen.dart';
import 'package:smartcar/dia_diem/map_screen_hai_phong.dart';
import 'package:smartcar/dia_diem/map_screen_nam_dinh.dart';
class DetailScreen1 extends StatelessWidget {
  final String item;
  const DetailScreen1({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item),
      ),
      body: MapScreen1(),
    );
  }
}
class DetailScreen2 extends StatelessWidget {
  final String item;
  const DetailScreen2({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item),
      ),
      body: MapScreen2(),
    );
  }
}
class DetailScreen3 extends StatelessWidget {
  final String item;
  const DetailScreen3({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item),
      ),
      body: MapScreen3(),
    );
  }
}
