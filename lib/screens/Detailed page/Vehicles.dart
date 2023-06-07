import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../widgets/vehi_wid.dart';
import '../noResult.dart';

class VehiclePage extends StatefulWidget {
  final String vcompanyName;

  const VehiclePage({Key? key, required this.vcompanyName}) : super(key: key);

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  List<dynamic> vehicles = [];
  bool isloading = true;
  bool _apiCalled = false;

  @override
  void initState() {
    super.initState();
    // Call your function here
    if (!_apiCalled) {
      fetchVehicles();
      print("invoked api");
      setState(() {
        _apiCalled = true;
      });
    }
  }

  Future<void> fetchVehicles() async {
    final response = await http.get(Uri.parse(
        "https://shamhadchoudhary.pythonanywhere.com/api/store/searchVehicle/?search=${widget.vcompanyName}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isloading = false;
        vehicles = data;
      });
      print(vehicles);
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
            widget.vcompanyName,
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
            : result());
  }

  result() {
    if (vehicles == []) {
      return NoResult();
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            return VehicleWidget(
              vehicle: vehicles[index],
            );
          },
        ),
      );
    }
  }

  noResult() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return VehicleWidget(
            vehicle: vehicles[index],
          );
        },
      ),
    );
  }
}
