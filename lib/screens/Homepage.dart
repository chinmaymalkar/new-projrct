import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widgets/comp_wid.dart';
import '../screens/SearchItem.dart';
import 'Additem.dart';
import 'drawer.dart';
import 'Notifier.dart';

class Homepage extends StatefulWidget implements PreferredSizeWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 40.0);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> companies = [];
  List<dynamic> searchData = [];
  bool isloading = true;
  bool _apiCalled = false;
  bool isRefreshing = false;
  bool _isFocused = false;

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call your function here
    if (!_apiCalled) {
      fetchCompanies();
      setState(() {
        _apiCalled = true;
      });
    }
  }

  Future<void> _refresh() async {
    // Simulate a delay before refreshing the data
    await Future.delayed(Duration(seconds: 1));
    isRefreshing = true;
    fetchCompanies();
  }

  void pressSearchIcon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(
        search: search.text,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.grey[300],
        child: GestureDetector(
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            resizeToAvoidBottomInset: false,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                gradient: LinearGradient(colors: [
                  Colors.blueAccent.shade100,
                  Colors.lightBlue.shade500,
                ], begin: Alignment.center, end: Alignment.centerRight),
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Additem();
                      },
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [
                      Colors.lightBlue.shade300,
                      Colors.blueAccent,
                    ])),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Inventory App",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Notifier();
                        }));
                      },
                      icon: Icon(
                        Icons.notifications,
                        size: 30,
                      ))
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(35.0),
                child: Container(
                  padding: EdgeInsets.all(18.0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        // onSubmitted: (value) => {pressSearchIcon()},
                        controller: search,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              pressSearchIcon();
                              pressSearchIcon();
                              search.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        search.clear();
                                        setState(
                                            () {}); // Update the suffixIcon to null
                                      },
                                    )
                                  : null;
                            },
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _isFocused = true;
                          });
                        },
                        onSubmitted: (value) {
                          pressSearchIcon();
                          setState(() {
                            _isFocused = false;
                          });
                        },
                        // focusNode: FocusNode(),
                      ),
                      if (_isFocused)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            search.clear();
                          },
                        ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              toolbarHeight: 135,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              elevation: 30,
            ),
            body: isloading
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.68,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            itemCount: companies.length,
                            itemBuilder: (context, index) {
                              return CompanyWidget(
                                vcompany: companies[index]['vcompany_name'],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            drawer: DrawerScreen(),
          ),
        ),
      ),
    );
  }

  Future<void> fetchCompanies() async {
    final posts = Hive.box(API_BOX).get('vCompanies', defaultValue: []);

    if (posts.isNotEmpty && isRefreshing == false) {
      setState(() {
        isloading = false;
        companies = posts;
      });
      print("Hived is Working");
    } else {
      final response = await http.get(Uri.parse(
          'https://shamhadchoudhary.pythonanywhere.com/api/store/vcompanies'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isloading = false;
          companies = data;
        });

        Hive.box(API_BOX).put('vCompanies', companies);
        final posts = Hive.box(API_BOX).get('vCompanies', defaultValue: []);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    // Navigator.of(context).pop();
  }
}
