import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../screens/Updateitem.dart';
import '../../screens/components/ImagePreview.dart';
import '../Homepage.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  Map<String, dynamic> fetchedItem = {};
  List<dynamic> fetchedLocation = [];
  bool isloading = true;
  bool _apiCalled = false;

  TextEditingController sellQuantity = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchedItem = widget.item;
    // Call your function here
    if (!_apiCalled) {
      fetchItem();
      if (fetchedItem.isNotEmpty) {
        fetchLocation();
      }
      print("invoked api Detailed Page");
      setState(() {
        _apiCalled = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  void _reloadPage() async {
    setState(() {});
    await fetchItem();
    fetchLocation();
  }

  Future<void> deleteItem(int id) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://shamhadchoudhary.pythonanywhere.com/api/store/item/$id/'));
      if (response.statusCode == 204) {
        print('Data with ID $id deleted successfully');
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> sellItemData() async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/item/${fetchedItem['id'].toString()}/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "company_name": {
        "company_name": fetchedItem['company_name']['company_name']
      },
      "vehicle_name": {
        "vcompany": {
          "vcompany_name": fetchedItem['vehicle_name']['vcompany']
              ['vcompany_name'],
        },
        "vehicle_name": fetchedItem['vehicle_name']['vehicle_name'],
        "wheeler": fetchedItem['vehicle_name']['wheeler']
      },
      "item_code": fetchedItem['item_code'],
      "description": fetchedItem['description'],
      "location": fetchedItem['location'],
      "quantity": fetchedItem['quantity'] - int.parse(sellQuantity.text),
      "MRP": fetchedItem['MRP'],
      "mech_selling_pr": fetchedItem['mech_selling_pr'],
      "cust_selling_pr": fetchedItem['cust_selling_pr']
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // request successful
      print(response.body);
    } else {
      // request failed
      print(response.reasonPhrase);
    }
  }

  _showSell() {
    sellQuantity.text = "1";
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sell to ..."),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {

                          if(_formKey.currentState!.validate()){
                            soldMethod(
                                "Mechanics", fetchedItem['mech_selling_pr']);
                            Navigator.of(context).pop(false);
                          }
                          // do

                          // do something when the second button is pressed
                        },
                        child: Text('Mechanics'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            soldMethod(
                                "Customer", fetchedItem['cust_selling_pr']);
                            Navigator.of(context).pop(false);
                          }
                          // do something when the first button is pressed
                        },
                        child: Text('Customer'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    width: 150,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: sellQuantity,
                        keyboardType: TextInputType.number,
                        validator:(value){
                          if(num.tryParse(value!)!>fetchedItem['quantity'])
                            return "Out of stock";
                          else if(num.tryParse(value)==0)
                            return "Invalid input";
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: Icon(Icons.production_quantity_limits),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Cancel')),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }

  soldMethod(String client, String price) {
    postDashBoard(client, price);
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Sold out',
        message: 'Item has been sold out successfully!!!',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    // do something when the first button is pressed

    sellItemData();

    _reloadPage();
  }

  Future<void> postDashBoard(String client, String price) async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/dashboardList/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "item_code": fetchedItem['item_code'],
      "description": fetchedItem['description'],
      "quantity": int.parse(sellQuantity.text),
      "sold_to": client,
      "sold_at": price
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      // request successful
      print(response.body);
    } else {
      // request failed
      print("Failed to Add to Dashboard");
      print(response.reasonPhrase);
    }
  }

  Future<void> fetchItem() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/item/${widget.item['id']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        fetchedItem = data;
        isloading = false;
      });
      print(fetchedItem);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchLocation() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/location/?location=${fetchedItem['location']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        fetchedLocation = data;
        isloading = false;
      });
      print(fetchedLocation);
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
        title: Text(fetchedItem['description'],

        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isloading
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : Center(
              child: Card(
                elevation: 50,
                shadowColor: Colors.black,
                // color: Colors.greenAccent[100],
                child: SizedBox(
                  width: 350,
                  height: 600,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          fetchedLocation.isNotEmpty
                              ? ImagePreview(
                                  imagePath:
                                      '${fetchedLocation[0]['photo_url']}')
                              : CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 32, 161, 236),
                                  radius: 86,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        AssetImage('assets/images/noImage.jpg'),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            fetchedItem['description'],
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Item Code : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['item_code'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Description : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['description'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Location : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['location'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Quantity : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['quantity'].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'MRP : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['MRP'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Mechanics Selling Price : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['mech_selling_pr'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Customer Selling Price : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                fetchedItem['cust_selling_pr'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showSell();
                                },
                                child: Text('Sell'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  displayDialog(context,
                                          "Are you sure you want to Update?")
                                      .then((value) {
                                    if (value) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Updateitem(item: fetchedItem);
                                      }));

                                      _reloadPage();
                                    }
                                  });
                                  // do something when the first button is pressed
                                },
                                child: Text('Update'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  {
                                    displayDialog(context,
                                            "Are you sure you want to Delete item ?")
                                        .then((value) {
                                      if (value == true) {
                                        deleteItem(fetchedItem['id']);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Homepage();
                                        }));
                                      }
                                    });
                                    // do something when the second button is pressed
                                  }
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Future displayDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No')),
          ],
        );
      });
}
