import 'package:flutter/material.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class TimeSelect extends StatefulWidget {
  TimeSelect({
    Key? key
  }) : super(key: key);

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
          padding: EdgeInsets.only(
              top: 100
          ),
          child: new Column(
            children: <Widget>[
//            hourMinute12H(),
              hourMinute15Interval(),
//            hourMinuteSecond(),
//            hourMinute12HCustomStyle(),
              new Container(
                margin: EdgeInsets.symmetric(
                    vertical: 50
                ),
                child: new Text(
                  _dateTime.hour.toString().padLeft(2, '0') + ':' +
                      _dateTime.minute.toString().padLeft(2, '0') + ':' +
                      _dateTime.second.toString().padLeft(2, '0'),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }


  /// SAMPLE
  Widget hourMinute12H(){
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinuteSecond(){
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinute15Interval(){
    return new TimePickerSpinner(
      spacing: 40,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinute12HCustomStyle(){
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.deepOrange
      ),
      highlightedTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.yellow
      ),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}