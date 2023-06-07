import 'package:LocManager/screens/DashBoard.dart';
import 'package:LocManager/screens/Homepage.dart';
import 'package:LocManager/screens/Profile.dart';
import 'package:LocManager/screens/Transaction.dart';
import 'package:LocManager/screens/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const String SETTINGS_BOX = 'settings';
const String API_BOX = "api_data";

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(SETTINGS_BOX);
  await Hive.openBox(API_BOX);
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)), // Wait for 3 seconds
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show splash screen widget
            return Splash();
          } else {
            // Navigate to main screen after waiting
            return Myapp();
          }
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory app',
        home: AnimatedSplashScreen(
          backgroundColor: Color(0xffe0e0e0),
          splashIconSize: double.infinity,
          nextScreen: Myapp(),
          splash: Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/splashy.gif'),
            ),
          ),
        ));
  }
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  int selectedindex = 1;
  final pages = [Notes(), Homepage(), DashBoard(), Profile()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFBFBFD),
      ),
      home: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.blue.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: NavigationBar(
                backgroundColor: Colors.white,
                elevation: 10,
                shadowColor: Colors.grey,

                // fixedColor: Colors.grey[500],
                selectedIndex: selectedindex,
                animationDuration: Duration(seconds: 2),
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,

                onDestinationSelected: (value) {
                  setState(() {
                    selectedindex = value;
                  });
                },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.grey,
                      ),
                      label: "Transaction",
                      selectedIcon: Icon(Icons.monetization_on)),
                  NavigationDestination(
                      icon: Icon(
                        Icons.home_outlined,
                        color: Colors.grey,
                      ),
                      label: "Home",
                      selectedIcon: Icon(Icons.home)),
                  NavigationDestination(
                      icon: Icon(
                        Icons.dashboard_customize_outlined,
                        color: Colors.grey,
                      ),
                      label: "DashBoard",
                      selectedIcon: Icon(Icons.dashboard_customize)),
                  NavigationDestination(
                      icon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.grey,
                      ),
                      label: "Profile",
                      selectedIcon: Icon(Icons.person)),
                ],
              ),
            ),
          ),
          body: pages[selectedindex],
        ),
      ),
    );
  }
}

class NotesModelAdapter extends TypeAdapter<NotesModel> {
  @override
  final int typeId = 0;

  @override
  NotesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesModel(
      title: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
