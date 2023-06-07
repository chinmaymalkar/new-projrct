import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
// import 'Notes.dart';
import 'Profile.dart';
import 'Transaction.dart';
import 'Additem.dart';
import 'Notifier.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                color: Colors.blueAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://www.w3schools.com/howto/img_avatar.png",
                      ),
                      radius: 50,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "DEVAKI ANAND AUTO SPARE",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      "abc@gmail.com",
                      style: TextStyle(color: Colors.white60),
                    )
                  ],
                ),
              ),
              MydrawerList(),
            ],
          ),
        ),
      ),
    ));
  }
}

Widget MydrawerList() {
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Column(
      children: [
        MydrawerItems(
          0,
          "Home",
          Icons.home,
          true,
        ),
        MydrawerItems(1, "Add Item", Icons.add, true),
        MydrawerItems(5, "Notifications", Icons.notifications, true),
        SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log Out"),
          ),
        )
      ],
    ),
  );
}

class MydrawerItems extends StatefulWidget {
  int id = 0;
  String title = "";
  IconData icon = Icons.add;
  bool selected = true;

  MydrawerItems(this.id, this.title, this.icon, this.selected);

  @override
  State<MydrawerItems> createState() =>
      _MydrawerItemsState(id, title, icon, selected);
}

class _MydrawerItemsState extends State<MydrawerItems> {
  int indexpage = 1;

  int getValue() {
    return indexpage;
  }

  final pages = [
    Homepage(),
    Additem(),
    Notes(),
    Profile(),
    Homepage(),
    Notifier(),
  ];

  int id;
  String title;
  IconData icon;
  bool selected;

  _MydrawerItemsState(
    this.id,
    this.title,
    this.icon,
    this.selected,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {});
          Navigator.pop(context);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return pages[id];
          }));
        },
        child: ListTile(
          leading: Icon(
            icon,
            size: 25,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
