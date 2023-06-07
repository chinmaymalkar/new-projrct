import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Detailed page/Detail.dart';

class Updateitem extends StatefulWidget {
  final Map<String, dynamic> item;

  const Updateitem({super.key, required this.item});

  @override
  State<Updateitem> createState() => _UpdateitemState();
}

class _UpdateitemState extends State<Updateitem> {
  TextEditingController companyName = TextEditingController();
  TextEditingController vCompanyName = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController itemCode = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController quantityLimit = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController mechanicsPrice = TextEditingController();
  TextEditingController customerPrice = TextEditingController();

  Map<String, dynamic> updatedData = {};

  @override
  void initState() {
    super.initState();
    companyName.text = widget.item['company_name']['company_name'];
    vCompanyName.text =
        widget.item['vehicle_name']['vcompany']['vcompany_name'];
    vehicleName.text = widget.item['vehicle_name']['vehicle_name'];
    itemCode.text = widget.item['item_code'];
    description.text = widget.item['description'];
    location.text = widget.item['location'];
    quantity.text = widget.item['quantity'].toString();
    quantityLimit.text = widget.item['quantity_limit'].toString();
    mrp.text = widget.item['MRP'];
    mechanicsPrice.text = widget.item['mech_selling_pr'];
    customerPrice.text = widget.item['cust_selling_pr'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Update Item"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              updatedData = await putItemData();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Item Updated")));
              if (updatedData != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailPage(item: updatedData);
                }));
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.branding_watermark),
                title: TextField(
                  controller: companyName,
                  decoration: InputDecoration(
                    labelText: "Brand/Company Name",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.branding_watermark),
                title: TextField(
                  controller: vCompanyName,
                  decoration: InputDecoration(
                    labelText: "Vehicle Company Name",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.directions_bike),
                title: TextField(
                  controller: vehicleName,
                  decoration: InputDecoration(
                    labelText: "Vehicle Name",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_outlined),
                title: TextField(
                  controller: itemCode,
                  decoration: InputDecoration(
                    labelText: "Item Code",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: TextField(
                  controller: description,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: TextField(
                  controller: location,
                  decoration: InputDecoration(
                    labelText: "Location",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart_checkout),
                title: TextField(
                  controller: quantity,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.production_quantity_limits),
                title: TextField(
                  controller: quantityLimit,
                  decoration: InputDecoration(
                    labelText: "Quantity Limit Notification",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.attach_money_outlined),
                title: TextField(
                  controller: mrp,
                  decoration: InputDecoration(
                    labelText: "MRP",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.sell_sharp),
                title: TextField(
                  controller: mechanicsPrice,
                  decoration: InputDecoration(
                    labelText: "Mechanics Selling Price",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.sell_sharp),
                title: TextField(
                  controller: customerPrice,
                  decoration: InputDecoration(
                    labelText: "Customer Selling Price",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> putItemData() async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/item/${widget.item['id'].toString()}/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "company_name": {"company_name": companyName.text.toUpperCase()},
      "vehicle_name": {
        "vcompany": {"vcompany_name": vCompanyName.text.toUpperCase()},
        "vehicle_name": vehicleName.text.toUpperCase(),
      },
      "item_code": itemCode.text,
      "description": description.text,
      "location": location.text,
      "quantity": quantity.text,
      "quantity_limit": quantityLimit.text,
      "MRP": mrp.text,
      "mech_selling_pr": mechanicsPrice.text,
      "cust_selling_pr": customerPrice.text
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // request successful
      // updatedData = json.decode(response.body);
      print(updatedData);
      return json.decode(response.body);
    } else {
      // request failed
      print(response.reasonPhrase);
    }
    return json.decode(response.reasonPhrase!);
  }
}
