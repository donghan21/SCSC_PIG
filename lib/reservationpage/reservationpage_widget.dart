import 'package:flutter/cupertino.dart';

import 'reservationpage_model.dart';
export 'reservationpage_model.dart';

import '/utils/model_utils.dart';
import '/components/navigation_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// HomePage Widget
class ReservationPageWidget extends StatefulWidget {
  const ReservationPageWidget({Key? key}) : super(key: key);

  @override
  _ReservationPageWidgetState createState() => _ReservationPageWidgetState();
}

class _ReservationPageWidgetState extends State<ReservationPageWidget> {
  late ReservationPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservationPageModel());

    _model.reasonController ??= TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.2,
            child: const NavigationBarWidget(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                      '날짜 선택',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w700,
                      ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    setState(() {
                      _model.selectedDay = date;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '시간 선택',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  onTimerDurationChanged: (duration) {
                    setState(() {
                      _model.selectedDay = DateTime(
                          _model.selectedDay!.year,
                          _model.selectedDay!.month,
                          _model.selectedDay!.day,
                          duration.inHours,
                          duration.inMinutes % 60);
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '사유 작성',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    controller: _model.reasonController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '사유를 작성해주세요',
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('예약하기'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
