import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'activity.item.g.dart';

@JsonSerializable()
class ActivityItem extends StatefulWidget {
  final String header;
  final List<CheckIn> checkIns;
  final String iconString;
  final GlobalKey<ActivityItemState> key;

  ActivityItem(this.key, this.header, this.checkIns, this.iconString);

  static Icon iconFromString(String iconString) => new Icon(ActivityItemState.activityIcons[iconString]);

  factory ActivityItem.fromJson(Map<String, dynamic> json) => _$ActivityItemFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityItemToJson(this);


  @override
  State<StatefulWidget> createState() {
    return new ActivityItemState();
  }
}

class ActivityItemState extends State<ActivityItem> {
  bool isExpanded = false;


  DateTime unfinishedCheckIn;


  toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Time:'),
                    Text(this.getTotalTime().toString() + ' hrs'),
                  ])),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Last Entry:'),
                    Text(widget.checkIns.isNotEmpty ? widget.checkIns.last.dateOfCheckOut() : 'N/A' ),
                    Text(widget.checkIns.isNotEmpty ? widget.checkIns?.last?.prettyTotalTime() : 'N/A')
                  ])),
          Padding(
            padding:EdgeInsets.all(10.0),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  RaisedButton(onPressed: null, child: Text('VIEW DETAILS')),
                  RaisedButton(onPressed: checkIn, child: Text(unfinishedCheckIn == null ? 'Check In' : 'Check Out'), color: unfinishedCheckIn == null ? Colors.lightBlue : Colors.blueGrey)
          ]))

        ]));
  }

  checkIn() {
    if (unfinishedCheckIn == null) {
      setState(() {
        unfinishedCheckIn = DateTime.now();
      });
    } else {
      setState(() {
        widget.checkIns.add(CheckIn(unfinishedCheckIn, DateTime.now()));

        unfinishedCheckIn = null;
      });

    }
  }

  getTotalTime([TimeSpans span = TimeSpans.Hours]) {
    double total = 0;
    widget.checkIns.forEach((checkIn) => total += checkIn.totalTime(span));
    return total;
  }

  static final activityIcons = <String, IconData>{
    'access_time': Icons.access_time,
    'access_alarm': Icons.access_alarm,
    'add_alarm': Icons.add_alarm,
    'alarm_on': Icons.alarm_on,
    'beach_access': Icons.beach_access,
    'business': Icons.business,
    'business_center': Icons.business_center,
    'calendar_today': Icons.calendar_today,
    'card_travel': Icons.card_travel,
    'contacts': Icons.contacts,
    'departure_board': Icons.departure_board,
    'event': Icons.event,
    'event_seat': Icons.event_seat,
    'group': Icons.group,
    'lightbulb_outline': Icons.lightbulb_outline,
    'security': Icons.security,
    'timer': Icons.timer
  };
}

enum TimeSpans { Seconds, Minutes, Hours, Days, Months }

@JsonSerializable()
class CheckIn {
  DateTime checkIn;
  DateTime checkOut;
  CheckIn(this.checkIn, this.checkOut);

  totalTime([TimeSpans span = TimeSpans.Hours]) {
    switch (span) {
      case TimeSpans.Seconds:
        return this.checkOut.difference(this.checkIn).inSeconds;
      case TimeSpans.Minutes:
        return this.checkOut.difference(this.checkIn).inMinutes;
      case TimeSpans.Hours:
        return this.checkOut.difference(this.checkIn).inHours;
      case TimeSpans.Days:
        return this.checkOut.difference(this.checkIn).inDays;
      case TimeSpans.Months:
        return this.checkOut.difference(this.checkIn).inDays / 30;
    }
  }

  prettyTotalTime() {
    return totalTime().toString() + '.' + (totalTime(TimeSpans.Minutes) - totalTime(TimeSpans.Hours)).toString() + ' hrs';
  }

  dateOfCheckOut() {
    return checkOut.month.toString() + '/' + checkOut.day.toString();
  }


  factory CheckIn.fromJson(Map<String, dynamic> json) => _$CheckInFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInToJson(this);
}


class DummyActivityItems {

  getDummies() {
    return <ActivityItem>[
      ActivityItem(
        new GlobalKey<ActivityItemState>(),
        'Advice',
        <CheckIn> [
          CheckIn(DateTime.now().add(Duration(hours: -2)), DateTime.now()),
        ],
        'access_time',
      ),
      ActivityItem(
        new GlobalKey<ActivityItemState>(),
        'Meetings',
        <CheckIn> [
          CheckIn(DateTime.now().add(Duration(hours: -8)), DateTime.now().add(Duration(hours: -4))),
          CheckIn(DateTime.now().add(Duration(hours: -24)), DateTime.now().add(Duration(hours: -18))),
        ],
        'access_alarm',
      )
    ];
  }
}