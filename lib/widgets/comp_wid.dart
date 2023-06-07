import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/Detailed page/Vehicles.dart';

class CompanyWidget extends StatefulWidget {
  final String vcompany;

  const CompanyWidget({Key? key, required this.vcompany}) : super(key: key);

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  List<dynamic> fetchedLocation = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/location/?location=${widget.vcompany}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        fetchedLocation = data;
      });
      print(fetchedLocation);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 200,
      height: 150,
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return VehiclePage(vcompanyName: widget.vcompany);
            }));
          },
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 78.0,
                height: 78.0,
                child: fetchedLocation.isNotEmpty
                    ? Image.network('${fetchedLocation[0]['photo_url']}')
                    : Transform.scale(
                        scale: 0.5,
                        // adjust the scale factor to resize the progress indicator
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
              ),
              // Text(
              //   widget.vcompany,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
          // trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
