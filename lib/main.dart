
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartcar/sign_page/login.dart';
import 'package:smartcar/common_page/map_screen.dart';
import 'common_page/detailscreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'common_page/lockscreen.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class HomeScreen extends StatefulWidget{
  @override
  const HomeScreen({super.key});
  State<HomeScreen> createState()=>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapScreen(),
    );
  }

}

class CustomSearch extends SearchDelegate {
  List<String> allData = [
    'Hà Nội-Nam Định',
    'Hà Nội-Hải Phòng',
    'Hà Nội-Thái Nguyên'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if(result=='Hà Nội-Nam Định'){
                      return DetailScreen1(item: result);
                    }
                    else if (result=='Hà Nội-Hải Phòng'){
                      return DetailScreen2(item: result);
                    }
                    else return DetailScreen3(item: result);
                  },
                )
            );
          }, //mở cửa sổ khác lên và đóng cửa sổ tìm kiếm
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if(result=='Nam Định'){
                      return DetailScreen1(item: result);
                    }
                    else if (result=='Hải Phòng'){
                      return DetailScreen2(item: result);
                    }
                    else return DetailScreen3(item: result);
                  },
                )
            );
          }, //mở cửa sổ khác lên và đóng cửa sổ tìm kiếm
        );
      },
    );
  }
}
