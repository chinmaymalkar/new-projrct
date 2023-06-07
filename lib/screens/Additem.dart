import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  State<Additem> createState() => _AdditemState();
}

final _formKey = GlobalKey<FormState>();

class _AdditemState extends State<Additem> {
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

  String _inputValue1 = " ";
  String _inputValue2 = " ";
  String _inputValue3 = " ";
  String _inputValue4 = " ";
  String _inputValue5 = " ";
  String _inputValue6 = " ";
  String _inputValue7 = " ";
  String _inputValue8 = " ";
  String _inputValue9 = " ";
  String _inputValue10 = " ";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          "Add Item",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("New Item Added")));

                postItemData();

                companyName.clear();
                vCompanyName.clear();
                vehicleName.clear();
                itemCode.clear();
                description.clear();
                location.clear();
                quantity.clear();
                quantityLimit.clear();
                mrp.clear();
                mechanicsPrice.clear();
                customerPrice.clear();
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 13,
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pls enter company name';
                      } else if (value.length > 10)
                        return "Input limit exceeded";

                      return null;
                    },
                    controller: companyName,
                    decoration: InputDecoration(
                      hintText: "Brand/Company Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue1 = value.toUpperCase();
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.local_activity),
                  title: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pls enter vehicle company name';
                      } else if (value.length > 10)
                        return "Input limit exceeded";

                      return null;
                    },
                    controller: vCompanyName,
                    decoration: InputDecoration(
                      hintText: "Vehicle Company Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue2 = value.toUpperCase();
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.directions_bike),
                  title: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pls enter vehicle name';
                      } else if (value.length > 10)
                        return "Input limit exceeded";

                      return null;
                    },
                    controller: vehicleName,
                    decoration: InputDecoration(
                      hintText: "Vehicle Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue3 = value.toUpperCase();
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner_outlined),
                  title: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pls enter Itemcode ';
                      } else if (value.length > 10)
                        return "Input limit exceeded";
                      return null;
                    },
                    controller: itemCode,
                    decoration: InputDecoration(
                      hintText: "Item Code",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue4 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pls enter the description';
                        } else if (value.length > 20)
                          return "Input limit exceeded";

                        return null;
                      },
                      controller: description,
                      decoration: InputDecoration(
                        hintText: "Description",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _inputValue5 = value;
                        });
                      }),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the Location';
                      } else if (value.length > 5)
                        return "Input limit exceeded";
                      else if (RegExp(r'[^\w\s]').hasMatch(value))
                        return "Enter the location correctly";
                      return null;
                    },
                    controller: location,
                    decoration: InputDecoration(
                      hintText: "Location",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue6 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_checkout),
                  title: TextFormField(
                    validator: (value) {
                      if (RegExp(r'^-?[0-9]+$').hasMatch(value!)) {
                        return null;
                      } else if (value.isEmpty)
                        return "Pls enter the quantity";
                      else if (value.length > 10) return "Input limit exceeded";
                      return "Enter the integer";
                    },
                    controller: quantity,
                    decoration: InputDecoration(
                      hintText: "Quantity",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue7 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.production_quantity_limits),
                  title: TextFormField(
                    validator: (value) {
                      if (RegExp(r'^-?[0-9]+$').hasMatch(value!)) {
                        return null;
                      } else if (value.isEmpty)
                        return "Pls enter the quantity";
                      else if (value.length > 10) return "Input limit exceeded";
                      return "Enter the integer";
                    },
                    controller: quantityLimit,
                    decoration: InputDecoration(
                      hintText: "Quantity Limit",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue7 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.production_quantity_limits),
                  title: TextFormField(
                    validator: (value) {
                      if (RegExp(r'^-?[0-9]+$').hasMatch(value!)) {
                        return null;
                      } else if (value.isEmpty)
                        return "Pls enter the MRP";
                      else if (value.length > 10) return "Input limit exceeded";
                      return "Enter the integer";
                    },
                    controller: mrp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "MRP",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue8 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.sell_sharp),
                  title: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (RegExp(r'^-?[0-9]+$').hasMatch(value!)) {
                        return null;
                      } else if (value.isEmpty)
                        return "Pls enter the Mechanics Selling price";
                      else if (value.length > 10) return "Input limit exceeded";
                      return "Enter the integer";
                    },
                    controller: mechanicsPrice,
                    decoration: InputDecoration(
                      hintText: "Mechanics Selling Price",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue9 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.sell_sharp),
                  title: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (RegExp(r'^-?[0-9]+$').hasMatch(value!)) {
                        return null;
                      } else if (value.isEmpty)
                        return "Pls enter the Customers selling price";
                      else if (value.length > 10) return "Input limit exceeded";
                      return "Enter the integer";
                    },
                    controller: customerPrice,
                    decoration: InputDecoration(
                      hintText: "Customer Selling Price",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputValue10 = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> postItemData() async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/items/');
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

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // request successful
      print(response.body);
    } else {
      // request failed
      print(response.reasonPhrase);
    }
  }
}
