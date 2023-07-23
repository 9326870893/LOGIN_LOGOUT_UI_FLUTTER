
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
// ignore: unused_import


class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";

  Color primary = const Color(0xffeef444c);

  bool isCheckIn = false;
  bool isCheckOut = false;

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  Future<void> _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.employeeId)
          .get();

      if (snap.docs.isNotEmpty) {
        String recordId = snap.docs[0].id;

        DocumentSnapshot snap2 = await FirebaseFirestore.instance
            .collection("Employee")
            .doc(recordId)
            .collection("Record")
            .doc(_getCurrentDate())
            .get();

        if (snap2.exists) {
          setState(() {
            checkIn = snap2['checkIn'];
            checkOut = snap2['checkOut'];
            isCheckIn = checkIn != "--/--";
            isCheckOut = checkOut != "--/--";
          });
        } else {
          setState(() {
            checkIn = "--/--";
            checkOut = "--/--";
            isCheckIn = false;
            isCheckOut = false;
          });
        }
      } else {
        setState(() {
          checkIn = "--/--";
          checkOut = "--/--";
          isCheckIn = false;
          isCheckOut = false;
        });
      }
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
        isCheckIn = false;
        isCheckOut = false;
      });
    }
  }

  Future<void> _updateCheckInTime() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.employeeId)
          .get();

      if (snap.docs.isNotEmpty) {
        String recordId = snap.docs[0].id;

        DocumentReference recordRef = FirebaseFirestore.instance
            .collection("Employee")
            .doc(recordId)
            .collection("Record")
            .doc(_getCurrentDate());

        DocumentSnapshot recordSnap = await recordRef.get();

        if (recordSnap.exists) {
          await recordRef.update({
            'checkIn': DateFormat.jm().format(DateTime.now()),
          });
        } else {
          await recordRef.set({
            'checkIn': DateFormat.jm().format(DateTime.now()),
            'checkOut': "--/--",
          });
        }

        setState(() {
          checkIn = DateFormat.jm().format(DateTime.now());
          isCheckIn = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateCheckOutTime() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.employeeId)
          .get();

      if (snap.docs.isNotEmpty) {
        String recordId = snap.docs[0].id;

        DocumentReference recordRef = FirebaseFirestore.instance
            .collection("Employee")
            .doc(recordId)
            .collection("Record")
            .doc(_getCurrentDate());

        DocumentSnapshot recordSnap = await recordRef.get();

        if (recordSnap.exists) {
          await recordRef.update({
            'checkOut': DateFormat.jm().format(DateTime.now()),
          });

          setState(() {
            checkOut = DateFormat.jm().format(DateTime.now());
            isCheckOut = true;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String _getCurrentDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome,",
                style: TextStyle(
                  color: Colors.black54,
                  //: "NexaRegular",
                  fontSize:20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee " + User.employeeId,
                style: TextStyle(
                  //: "NexaBold",
                  fontSize:18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  //: "NexaBold",
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                            //: "NexaRegular",
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                        if (isCheckIn) // Show check-in time only if available
                          Text(
                            checkIn,
                            style: TextStyle(
                              //: "NexaBold",
                              fontSize: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 1,
                    width: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                            //: "NexaRegular",
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          checkOut,
                          style: TextStyle(
                            //: "NexaBold",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  //: "NexaRegular",
                  fontSize:20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.jm().format(DateTime.now()),
                    style: TextStyle(
                      //: "NexaRegular",
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: SlideAction(
                      text: "Slide to Check In",
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        //: "NexaRegular",
                      ),
                      //color: primary,
                      sliderButtonIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: screenWidth / 15,
                      ),
                      onSubmit: () {
                        _updateCheckInTime();
                      },
                    ),
                  ),
                  if (isCheckIn)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SlideAction(
                        text: "Slide to Check Out",
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 22,
                          //: "NexaRegular",
                        ),
                        //color: primary,
                        sliderButtonIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: screenWidth / 15,
                        ),
                        onSubmit: () {
                          _updateCheckOutTime();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}













// //import 'package:attendanceapp/model/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:slide_to_act/slide_to_act.dart';

// class TodayScreen extends StatefulWidget {
//   const TodayScreen({Key? key}) : super(key: key);

//   @override
//   _TodayScreenState createState() => _TodayScreenState();
// }

// class _TodayScreenState extends State<TodayScreen> {
//   double screenHeight = 0;
//   double screenWidth = 0;

//   String checkIn = "--/--";
//   String checkOut = "--/--";

//   Color primary = const Color(0xffeef444c);
  
//   bool isCheckIn = false;
//   bool isCheckOut = false;

//   @override
//   void initState() {
//     super.initState();
//     _getRecord();
//   }

//   void _getRecord() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection("Employee")
//           .where('id', isEqualTo: User.employeeId)
//           .get();

      

//       DocumentSnapshot snap2 = await FirebaseFirestore.instance
//           .collection("Employee")
//           .doc(snap.docs[0].id)
//           .collection("Record")
//           .doc(recordId)
//           .get();

//       if (snap2.exists) {
//         await FirebaseFirestore.instance
//             .collection("Employee")
//             .doc(snap.docs[0].id)
//             .collection("Record")
//             .doc(recordId)
//             .update({
//           'checkIn': DateFormat.jm().format(DateTime.now()),
//         });

//         setState(() {
//           checkIn = snap2['checkIn'];
//           checkOut = snap2['checkOut'];
//           isCheckIn = checkIn != "--/--";
//           isCheckOut = checkOut != "--/--";
//         });
//       } else {
//         DateTime now = DateTime.now();
//         String formattedCheckIn = DateFormat.jm().format(now);
//         String formattedCheckOut = "--/--";

//         await FirebaseFirestore.instance
//             .collection("Employee")
//             .doc(snap.docs[0].id)
//             .collection("Record")
//             .doc(recordId)
//             .set({
//           'checkIn': formattedCheckIn,
//           'checkOut': formattedCheckOut,
//         });

//         setState(() {
//           checkIn = formattedCheckIn;
//           checkOut = formattedCheckOut;
//           isCheckIn = true;
//           isCheckOut = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         checkIn = "--/--";
//         checkOut = "--/--";
//         isCheckIn = false;
//         isCheckOut = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: const EdgeInsets.only(top: 32),
//               child: Text(
//                 "Welcome,",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   //: "NexaRegular",
//                   fontSize: screenWidth / 20,
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Employee " + User.employeeId,
//                 style: TextStyle(
//                   //: "NexaBold",
//                   fontSize: screenWidth / 18,
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: const EdgeInsets.only(top: 32),
//               child: Text(
//                 "Today's Status",
//                 style: TextStyle(
//                   //: "NexaBold",
//                   fontSize: screenWidth / 18,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 12, bottom: 32),
//               height: 150,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Check In",
//                           style: TextStyle(
//                             //: "NexaRegular",
//                             fontSize: screenWidth / 20,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         if (isCheckIn) // Show check-in time only if available
//                           Text(
//                             checkIn,
//                             style: TextStyle(
//                               //: "NexaBold",
//                               fontSize: screenWidth / 18,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   VerticalDivider(
//                     color: Colors.grey[300],
//                     thickness: 1,
//                     width: 1,
//                     indent: 20,
//                     endIndent: 20,
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Check Out",
//                           style: TextStyle(
//                             //: "NexaRegular",
//                             fontSize: screenWidth / 20,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         Text(
//                           checkOut,
//                           style: TextStyle(
//                             //: "NexaBold",
//                             fontSize: screenWidth / 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: const EdgeInsets.only(top: 32),
//               child: Text(
//                 DateFormat('dd MMMM yyyy').format(DateTime.now()),
//                 style: TextStyle(
//                   //: "NexaRegular",
//                   fontSize: screenWidth / 20,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 12, bottom: 32),
//               height: 250,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     DateFormat.jm().format(DateTime.now()),
//                     style: TextStyle(
//                       //: "NexaRegular",
//                       fontSize: screenWidth / 12,
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 32),
//                     child: SlideAction(
//                       text: "Slide to Check In",
//                       textStyle: TextStyle(
//                         color: Colors.white,
//                         fontSize: screenWidth / 22,
//                         //: "NexaRegular",
//                       ),
//                       //color: primary,
//                       sliderButtonIcon: Icon(
//                         Icons.chevron_right,
//                         color: Colors.white,
//                         size: screenWidth / 15,
//                       ),
//                       onSubmit: () {},
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:slide_to_act/slide_to_act.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:timesheet_application/main.dart';

// // class TodayScreen extends StatefulWidget {
// //   const TodayScreen({super.key});

// //   @override
// //   State<TodayScreen> createState() => _TodayScreenState();
// // }

// // class _TodayScreenState extends State<TodayScreen> {
// //   double screenHeight = 0;
// //   double screenWidth = 0;

// //   String checkIn = "--/--";
// //   String checkOut = "--/--";

// //   Color primary = const Color(0xFFFf444c);
// //   int currentIndex = 1;

// //   @override
// //   void initState(){
// //     super.initState();
// //     _getRecord();
// //   }
// //   void _getRecord() async {
// //     try{

                 
// //                   QuerySnapshot snap = await FirebaseFirestore.instance.collection("Employee")
                 
// //                   .where("Id",isEqualTo:User
// //                   .username).get();
// //                   print(snap.docs[0].id);
                

// //                   DocumentSnapshot snap2 = await FirebaseFirestore.instance
                  

// //                   .collection("Employee")
// //                   .doc(snap.docs[0].id)
// //                   .collection("Record")
// //                   .doc(DateFormat("dd MMMM YYYY").format(DateTime.now()))
// //                   .get();

// //               setState((){
// //                   checkIn = snap2['checkIn'];
               
// //                 checkOut = snap2['checkOut'];
// //               });
// //   }
// //   catch(e){
// //      setState((){
// //               checkIn="--/--";
// //               checkOut = "--/--";

// //   });
// //   }
// //   print(checkIn);
// //   print(checkOut);

// //   @override
// //   Widget build(BuildContext context) {
// //     screenHeight = MediaQuery.of(context).size.height;
// //     screenWidth = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           children: [
// //             Container(
// //               alignment: Alignment.centerLeft,
// //               margin: const EdgeInsets.only(top: 30.0),
// //               child: Text(
// //                 "Welcome",
// //                 style: TextStyle(
// //                   color: Colors.black54,
// //                   fontSize: screenWidth / 20,
// //                   ////: "NexaRegula",
// //                 ),
// //               ),
// //             ),
// //             Container(
// //               alignment: Alignment.centerLeft,
// //               child: Text(
// //                 "Employee", //$ user.username.toString(),
// //                 style: TextStyle(
// //                   fontSize: screenWidth / 18,
// //                   ////: "NexaBold",
// //                 ),
// //               ),
// //             ),
// //             Container(
// //               alignment: Alignment.centerLeft,
// //               margin: const EdgeInsets.only(top: 30.0),
// //               child: Text(
// //                 "Today's Status",
// //                 style: TextStyle(
// //                   color: Colors.black54,
// //                   fontSize: screenWidth / 18,
// //                   // //: "NexaBold",
// //                 ),
// //               ),
// //             ),
// //             Container(
// //               margin: const EdgeInsets.only(top: 20.0, bottom: 32),
// //               height: 150,
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black26,
// //                     blurRadius: 10,
// //                     offset: Offset(2, 2),
// //                   ),
// //                 ],
// //                 borderRadius: BorderRadius.all(
// //                   Radius.circular(20.0),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Expanded(
// //                       child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         "check In",
// //                         style: TextStyle(
// //                             // //: "NexaRegular",
// //                             fontSize: screenHeight / 20,
// //                             color: Colors.black54),
// //                       ),
// //                       Text(
// //                         checkIn,
// //                         style: TextStyle(
// //                           // //: "NexaBold",
// //                           fontSize: screenHeight / 18,
// //                           color: Colors.black54,
// //                         ),
// //                       ),
// //                     ],
// //                   )),
// //                   Expanded(
// //                       child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         "check Out",
// //                         style: TextStyle(
// //                             //  //: "NexaRegular",
// //                             fontSize: screenHeight / 20,
// //                             color: Colors.black54),
// //                       ),
// //                       Text(
// //                         checkOut,
// //                         style: TextStyle(
// //                           //  //: "NexaBold",
// //                           fontSize: screenHeight / 18,
// //                           color: Colors.black54,
// //                         ),
// //                       ),
// //                     ],
// //                   ))
// //                 ],
// //               ),
// //             ),
// //             Container(
// //               alignment: Alignment.centerLeft,
// //               child: Text(
// //                 "20:00:01",
// //                 style: TextStyle(
// //                     //  //: "NexaRegular",
// //                     fontSize: screenHeight / 20,
// //                     color: Colors.black54),
// //               ),
// //             ),
// //             Container(
// //                 alignment: Alignment.centerLeft,
// //                 child: RichText(
// //                     text: TextSpan(
// //                         text: DateTime.now().day.toString(),
// //                         style: TextStyle(
// //                           color: primary,
// //                           fontSize: screenWidth / 18,
// //                           //  //: "NexaBold",
// //                         ),
// //                         children: [
// //                       TextSpan(
// //                           text: DateFormat("MMMM YYYY").format(DateTime.now()),
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: screenWidth / 20,
// //                             //  //: "NexaBold"))
// //                           )),
// //                     ]))),
// //             StreamBuilder(
// //                 stream: Stream.periodic(const Duration(seconds: 1)),
// //                 builder: (context, snapshot) {
// //                   return Container(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text(
// //                       DateFormat("hh:mm:ss a").format(DateTime.now()),
// //                       style: TextStyle(
// //                           // //: "NexaBold",
// //                           fontSize: screenHeight / 18,
// //                           color: Colors.black54),
// //                     ),
// //                   );
// //                 }),
// //             Container(
// //               margin: const EdgeInsets.only(top: 24.0),
// //               child: Builder(builder: (context) {
// //                 final GlobalKey<SlideActionState> key = GlobalKey();

// //                 return SlideAction(
// //   text: 'Slide to check In',
// //   textStyle: const TextStyle(
// //     color: Colors.black54,
// //     fontSize: 20.0,
// //   ),
// //   outerColor: Colors.white,
// //   innerColor: primary,
// //   key: key,
// //   onSubmit: () async {
// //     print(DateTime.now().toString());

// //     QuerySnapshot snap = await FirebaseFirestore.instance
// //         .collection("Employee")
// //         .where("Id", isEqualTo: User.username)
// //         .get();
// //     print(snap.docs[0].id);
// //     print(DateFormat("dd MMMM YYYY").format(DateTime.now()));

// //     DocumentSnapshot snap2 = await FirebaseFirestore.instance
// //         .collection("Employee")
// //         .doc(snap.docs[0].id)
// //         .collection("Record")
// //         .doc(DateFormat("dd MMMM YYYY").format(DateTime.now()))
// //         .get();

// //     try {
// //       String checkIn = snap2["checkIn"];

// //       await FirebaseFirestore.instance
// //           .collection("Employee")
// //           .doc(snap.docs[0].id)
// //           .collection("Record")
// //           .doc(DateFormat("dd MMMM YYYY").format(DateTime.now()))
// //           .update({
// //         "checkIn": checkIn,
// //         "checkOut": DateFormat("hh mm").format(DateTime.now()),
// //       });
// //     } catch (e) {
// //       await FirebaseFirestore.instance
// //           .collection("Employee")
// //           .doc(snap.docs[0].id)
// //           .collection("Record")
// //           .doc(DateFormat("dd MMMM YYYY").format(DateTime.now()))
// //           .set({
// //         "checkIn": DateFormat("hh mm").format(DateTime.now()),
// //       });
// //     }
// //   },
// // ),

// //               }),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return const TodayScreen();
// //   }
// // }

