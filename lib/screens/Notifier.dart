import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 'Detailed page/Detail.dart';

class Notifier extends StatefulWidget {
  const Notifier({Key? key}) : super(key: key);

  @override
  State<Notifier> createState() => _NotifierState();
}

class _NotifierState extends State<Notifier> {
  bool _apiCalled = false;
  bool isLoading = true;
  List<dynamic> demand = [];
  Map<String, dynamic> item = {};

  @override
  void initState() {
    super.initState();
    // Call your function here
    fetchQNotifier();

    if (!_apiCalled) {
      print("invoked api");
      setState(() {
        _apiCalled = true;
      });
    }
  }

  Future<void> fetchQNotifier() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/qNotifier/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        demand = getItems(data);
        isLoading = false;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  List getItems(List items) {
    List demand = [];
    for (int i = 0; i < items.length; i++) {
      if (items[i]['quantity'] <= items[i]['quantity_limit']) {
        demand.add(items[i]);
      }
    }
    return demand;
  }

  Future<void> fetchItem(String id) async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/item/${id}'));

    if (response.statusCode == 200) {
      print("Api Called Successfull with code - ${response.statusCode}");
      final data = jsonDecode(response.body);
      item = data;
    } else {
      print("Api called Failed with code - ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: kWhiteColor,
        elevation: kRadius,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.blue),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: action,
      ),
      body: ListView.separated(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: demand.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(notifierLogo), fit: BoxFit.cover))),
              title: Text(demand[index]['description'],
                  style: TextStyle(color: kDarkColor)),
              subtitle: Text(
                  '${demand[index]['vehicle_name']['vcompany']['vcompany_name']} - ${demand[index]['vehicle_name']['vehicle_name']}',
                  style: TextStyle(color: kLightColor)),
              trailing: Text('Qty - ${demand[index]['quantity']}'),
              onTap: () async => {
                await fetchItem(demand[index]['id'].toString()),
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(item: item))),
              },
              enabled: true,
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          }),
    );
  }
}
