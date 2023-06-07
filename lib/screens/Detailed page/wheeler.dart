import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../widgets/vehi_wid.dart';
import 'Vehicles.dart';

class WheelerPage extends StatefulWidget {
  final String vcompanyName;

  const WheelerPage({Key? key, required this.vcompanyName}) : super(key: key);

  @override
  State<WheelerPage> createState() => _WheelerPageState();
}

class _WheelerPageState extends State<WheelerPage> {
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
          "CHOOSE WHEELER",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15, left: 15, bottom: 5, right: 15),
              height: 150,
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VehiclePage(
                        vcompanyName: widget.vcompanyName,
                      );
                    }));
                  },
                  title: Center(
                      child: Text(
                    "TWO WHEELER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: 150,
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VehiclePage(
                        vcompanyName: widget.vcompanyName,
                      );
                    }));
                  },
                  title: Center(
                      child: Text(
                    "THREE WHEELER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: 150,
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VehiclePage(
                        vcompanyName: widget.vcompanyName,
                        // wheeler: "4 Wheeler");
                      );
                    }));
                  },
                  title: Center(
                      child: Text(
                    "FOUR WHEELER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
