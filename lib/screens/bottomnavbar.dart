// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:inventordeve/screens/DashBoard.dart';
// import 'package:inventordeve/screens/Homepage.dart';
// import 'package:inventordeve/screens/Notes.dart';
// import 'package:inventordeve/screens/Profile.dart';
//
//
// List<Widget> screens = [
//   Homepage(),
//   Notes(),
//   Profile(),
//   DashBoard(),
//
// ];
//
// class CustomBottomNavigationBar extends StatefulWidget {
//   @override
//   CustomBottomNavigationBarState createState() =>
//       CustomBottomNavigationBarState();
// }
//
// class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
//     with TickerProviderStateMixin {
//   late AnimationController firstIconController;
//   late Animation<double> firstIconAngle;
//   late Animation<double> firstIconSize;
//
//   late AnimationController secondIconController;
//   late Animation<double> secondIconAngle;
//   late Animation<double> secondIconSize;
//
//   late AnimationController thirdIconController;
//   late Animation<double> thirdIconAngle;
//   late Animation<double> thirdIconSize;
//
//   late AnimationController fourthIconController;
//   late Animation<double> fourthIconAngle;
//   late Animation<double> fourthIconSize;
//
//
//   int currentIndex = 0;
//
//   int beginningIconDuration = 1000;
//   int reverseIconDuration = 200;
//
//   double iconAngle = 0.4;
//
//   double expandedIconSize = 50;
//   double normalIconSize = 30;
//
//   Curve forwardingCurve = Curves.elasticOut;
//   Curve reversingCurve = Curves.easeIn;
//
//   List<IconData> listOfIcons = [
//     FontAwesomeIcons.moneyBill,
//     FontAwesomeIcons.home,
//     FontAwesomeIcons.notesMedical,
//     FontAwesomeIcons.personCircleCheck,
//
//   ];
//
//   int pageIndex = 0;
//   late PageController pageController;
//
//   void onPageChanged(int page) {
//     setState(() {
//       this.pageIndex = page;
//     });
//   }
//
//   void onTabTapped(int index) {
//     this.pageController.animateToPage(index,
//         duration: Duration(milliseconds: 1000),
//         curve: Curves.fastLinearToSlowEaseIn);
//   }
//
//   @override
//   void initState() {
//     pageController = PageController(initialPage: pageIndex);
//
//     firstIconController = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: beginningIconDuration),
//         reverseDuration: Duration(milliseconds: reverseIconDuration));
//
//     firstIconAngle = Tween<double>(begin: 0, end: iconAngle).animate(
//       CurvedAnimation(
//           parent: firstIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     firstIconSize =
//     Tween<double>(begin: normalIconSize, end: expandedIconSize).animate(
//       CurvedAnimation(
//           parent: firstIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     secondIconController = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: beginningIconDuration),
//         reverseDuration: Duration(milliseconds: reverseIconDuration));
//
//     secondIconAngle = Tween<double>(begin: 0, end: iconAngle).animate(
//       CurvedAnimation(
//           parent: secondIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     secondIconSize =
//     Tween<double>(begin: normalIconSize, end: expandedIconSize).animate(
//       CurvedAnimation(
//           parent: secondIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     thirdIconController = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: beginningIconDuration),
//         reverseDuration: Duration(milliseconds: reverseIconDuration));
//
//     thirdIconAngle = Tween<double>(begin: 0, end: iconAngle).animate(
//       CurvedAnimation(
//           parent: thirdIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     thirdIconSize =
//     Tween<double>(begin: normalIconSize, end: expandedIconSize).animate(
//       CurvedAnimation(
//           parent: thirdIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     fourthIconController = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: beginningIconDuration),
//         reverseDuration: Duration(milliseconds: reverseIconDuration));
//
//     fourthIconAngle = Tween<double>(begin: 0, end: iconAngle).animate(
//       CurvedAnimation(
//           parent: fourthIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     fourthIconSize =
//     Tween<double>(begin: normalIconSize, end: expandedIconSize).animate(
//       CurvedAnimation(
//           parent: fourthIconController,
//           curve: forwardingCurve,
//           reverseCurve: reversingCurve),
//     )..addListener(() {
//       setState(() {});
//     });
//
//
//
//     firstIconController.forward();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     firstIconController.dispose();
//     secondIconController.dispose();
//     thirdIconController.dispose();
//     fourthIconController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xff8655F9),
//       body: Stack(
//
//         children: [
//           PageView(
//             children: screens,
//             onPageChanged: onPageChanged,
//             controller: pageController,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.1),
//                         blurRadius: 40,
//                       )
//                     ],
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 75,
//                   color: Colors.transparent,
//                   alignment: Alignment.topCenter,
//                   child: ListView.builder(
//                     itemCount: 5,
//                     scrollDirection: Axis.horizontal,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth *0.3,
//                     ),
//                     itemBuilder: (context, index) => InkWell(
//                       onTap: () {
//                         setState(() {
//                           currentIndex = index;
//                           HapticFeedback.lightImpact();
//                         });
//
//                         onTabTapped(index);
//                         if (currentIndex == 0) {
//                           firstIconController.forward();
//                           secondIconController.reverse();
//                           thirdIconController.reverse();
//                           fourthIconController.reverse();
//                         } else if (currentIndex == 1) {
//                           firstIconController.reverse();
//                           secondIconController.forward();
//                           thirdIconController.reverse();
//                           fourthIconController.reverse();
//                         } else if (currentIndex == 2) {
//                           firstIconController.reverse();
//                           secondIconController.reverse();
//                           thirdIconController.forward();
//                           fourthIconController.reverse();
//                         } else if (currentIndex == 3) {
//                           firstIconController.reverse();
//                           secondIconController.reverse();
//                           thirdIconController.reverse();
//                           fourthIconController.forward();
//                         } else if (currentIndex == 4) {
//                           firstIconController.reverse();
//                           secondIconController.reverse();
//                           thirdIconController.reverse();
//                           fourthIconController.reverse();
//                         }
//                       },
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       child: AnimatedPadding(
//                         padding: EdgeInsets.only(
//                             top: index == currentIndex ? 0 : 30),
//                         duration: Duration(milliseconds: 400),
//                         curve: Curves.fastLinearToSlowEaseIn,
//                         child: Container(
//                           width: screenWidth * .18,
//                           alignment: Alignment.topCenter,
//                           child: Transform.rotate(
//                             angle: index == 0
//                                 ? firstIconAngle.value
//                                 : index == 1
//                                 ? secondIconAngle.value
//                                 : index == 2
//                                 ? thirdIconAngle.value
//                                 : index == 3
//                                 ? fourthIconAngle.value
//
//                                 : 0,
//                             child: FaIcon(
//                               listOfIcons[index],
//                               size: index == 0
//                                   ? firstIconSize.value
//                                   : index == 1
//                                   ? secondIconSize.value
//                                   : index == 2
//                                   ? thirdIconSize.value
//                                   : index == 3
//                                   ? fourthIconSize.value
//
//                                   : 0,
//                               color: index == currentIndex
//                                   ? Color(0xffffb20a)
//                                   : Colors.black26,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }