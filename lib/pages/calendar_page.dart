import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => CalendardPageState();
}

class CalendardPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();
void _onDaySelected(DateTime day, DateTime focusedDay){
  setState(() {
    today = day;
  });
}
  @override

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:const Text("CalendarPage")),
    body:content(),
    );
  }

Widget content(){
  return Column(
    children: [
      Text ("Selected Day " + today.toString().split(" ")[0]),
      Container(
        child: TableCalendar
             (
              locale: "en_US",
              rowHeight: 100,
              focusedDay: today, 
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
             firstDay: DateTime.utc(2010, 10, 16), 
             lastDay: DateTime.utc(2030, 3, 14),
             onDaySelected: _onDaySelected,
             )
      ),
    ],
  );
}
}

