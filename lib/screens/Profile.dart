import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'models/Imagepicker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ImagePickerController controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor:Colors.grey[300],
          extendBodyBehindAppBar: true,
          extendBody: true,
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
              "Profile",
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),


          body: Stack(
            children: [
              Container(

                child: SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 73.0,
                      backgroundColor: Colors.teal,
                      child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70.0,
                                backgroundImage:  NetworkImage(
                                  "https://www.w3schools.com/howto/img_avatar.png",
                                ),

                              ),

                            ],
                          ),

                      ),
                    ),
                    Text(
                      'DEVAKI ANAND',
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Auto spare Shop',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        color: Colors.teal.shade200,
                        fontSize: 20.0,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.teal.shade100,
                      ),
                    ),
                    Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.teal,
                          ),
                          title: Text(
                            '+918446222992',
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontFamily: 'Source Sans Pro',
                              fontSize: 20.0,
                            ),
                          ),
                        )),
                    Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          title: Text(
                            'chinmaymalkar23@gmail.com',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.teal.shade900,
                                fontFamily: 'Source Sans Pro'),
                          ),
                        ))
                  ],
                )),
              ),
            ],
          )),
    );
  }
}
