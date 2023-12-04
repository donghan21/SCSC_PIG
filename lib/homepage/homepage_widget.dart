import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage_model.dart';
export 'homepage_model.dart';

import '/utils/model_utils.dart';
import '/components/navigation_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// HomePage Widget
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  late ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<DateTime, List<Event>> events2 = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _initializeEvents().then((value) => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> _initializeEvents() async {
    events2 = await returnEvents();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    if (_selectedEvents.value.isEmpty) {
      _selectedEvents.value.add(Event('해당 날짜에 예약내역이 없습니다'));
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _model.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    List<Event> events = [];
    events2.forEach((key, value) {
      if (isSameDay(key, day)) {
        events.addAll(value);
      }
    });

    return events;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      if (_selectedEvents.value.isEmpty) {
        _selectedEvents.value.add(Event('해당 날짜에 예약내역이 없습니다'));
      }
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.2,
            child: NavigationBarWidget(),
          ),

          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                color: Colors.white,
                child: TableCalendar<Event>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  availableCalendarFormats: {
                    CalendarFormat.month: '달',
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.white,
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () {},
                              title: Text('${value[index]}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Events Class and Function
Future<Map<DateTime, List<Event>>> returnEvents() async {

  final reservationData = await FirebaseFirestore.instance
      .collection('reservation')
      .get()
      .then((value) => value.docs);

  // make event maps
  Map<DateTime, List<Event>> eventsMap = {};
  for (var i = 0; i < reservationData.length; i++) {
    final reservation = reservationData[i];
    Map<String, dynamic> reservationMap = reservation.data();

    DateTime startTime = reservationMap['start_time'].toDate();
    DateTime endTime = reservationMap['end_time'].toDate();
    String content = reservationMap['content'];
    String name = reservationMap['name'];
    String number = reservationMap['number'].toString();
    DateTime date = DateTime(startTime.year, startTime.month, startTime.day);

    Event event = Event(
        '예약자: $name\n연락처: $number\n내용: $content\n시작시간: ${startTime.hour}:${startTime.minute}\n종료시간: ${endTime.hour}:${endTime.minute}'
    );

    if (eventsMap.containsKey(date)) {
      eventsMap[startTime]!.add(event);
    } else {
      eventsMap[startTime] = [event];
    }
  }

  Map<DateTime, List<Event>> eventsMap2 = {
    DateTime(2023, 11, 20): [
      const Event('Event A0'),
      const Event('Event B0'),
      const Event('Event C0'),
    ],
  };
  return eventsMap;
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
