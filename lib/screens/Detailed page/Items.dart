import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../widgets/item_wid.dart';
import '../noResult.dart';

class ItemPage extends StatefulWidget {
  final String vehicle;

  const ItemPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<dynamic> items = [];
  bool isloading = true;
  bool _apiCalled = false;

  @override
  void initState() {
    super.initState();
    // Call your function here
    if (!_apiCalled) {
      fetchItems();
      print("invoked api");
      setState(() {
        _apiCalled = true;
      });
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        "https://shamhadchoudhary.pythonanywhere.com/api/store/searchItem/?search=${widget.vehicle}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isloading = false;
        items = data;
      });
      print(items);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 15,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              gradient: LinearGradient(colors: [
                Colors.lightBlue.shade300,
                Colors.blueAccent,
              ])),
        ),
        title: Text(
          widget.vehicle,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isloading
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : result(),
    );
  }

  result() {
    if (items.isEmpty) {
      return NoResult();
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemWidget(
              item: items[index],
            );
          },
        ),
      );
    }
  }
}
