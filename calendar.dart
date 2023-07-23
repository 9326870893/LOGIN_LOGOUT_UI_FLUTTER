import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState()
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Page"),
      ),
      body: content(), // Add this line to display the content
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("Selected Day: " + today.toString().split(" ")[0]),
          Container(
            child: TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime(2023, 05, 26),
              lastDay: DateTime(2030, 10, 30),
              onDaySelected: _onDaySelected,
            ),
          ),
          const Text("Check In Check Out Button"),
          Container(
            child: Container(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TodayScreen()))
                },
                child: const Text('Click'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:timesheet_application/Screens/Diologue.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   DateTime today = DateTime.now();

//   void _onDaySelected(DateTime day, DateTime focuseDay) {
//     setState(() {
//       today = day;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Calendar Page"),
//       ),
//     );
//   }

//   Widget content() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           Text("Selected Day =" + today.toString().split("")[0]),
//           Container(
//             child: TableCalendar(
//               locale: "en_US",
//               rowHeight: 43,
//               headerStyle:
//                  const HeaderStyle(formatButtonVisible: false, titleCentered: true),
//               availableGestures: AvailableGestures.all,
//               selectedDayPredicate: (day) => isSameDay(day, today),
//               focusedDay: today,
//               firstDay: DateTime(2023, 05, 26),
//               lastDay: DateTime(2030, 10, 30),
//               onDaySelected: _onDaySelected,
//             ),
//           ),
//          const Text("check In check Out Button"),
//           Container(
//               child: Container(
//             child: TextButton(
//               style: ButtonStyle(
//                 foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//               ),
//               onPressed: () => {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const BoxPage()))
//               },
//               child: const Text('click'),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_calendar/calendar.dart';

// // class ProfileScreen extends StatefulWidget {
// //   const ProfileScreen({super.key});

// //   @override
// //   State<ProfileScreen> createState() => _ProfileScreenState();
// // }

// // class _ProfileScreenState extends State<ProfileScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SfCalendar(
// //         view: CalendarView.month,
// //       ),
// //     );
// //   }
// // }