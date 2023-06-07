import 'package:flutter/material.dart';

import '../screens/Detailed page/Items.dart';

class VehicleWidget extends StatelessWidget {
  // final String vehicle;
  final Map<String, dynamic> vehicle;

  const VehicleWidget({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ItemPage(
                    vehicle: vehicle['vehicle_name'],
                  );
                }));
              },
              leading: Icon(Icons.precision_manufacturing_outlined),
              title: Text(vehicle['vehicle_name']),
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
