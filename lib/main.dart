import 'package:flutter/material.dart';
import 'package:timehedron_f/activity.item.dart';
import 'package:timehedron_f/add.activity.dart';

void main() => runApp(Activities());



class Activities extends StatefulWidget {
  ActivitiesState createState() =>  ActivitiesState();
}



class ActivitiesState extends State<Activities> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  // TODO: Get this data from database
  List<ActivityItem> items;

  VoidCallback _showBottomSheetCallback;

  PersistentBottomSheetController _bottomSheetController;
  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
    items = DummyActivityItems().getDummies();
  }

  void _toggleBottomSheet() {
    if (_showBottomSheetCallback == null) {
      _bottomSheetController.close();
    } else {
      _showBottomSheetCallback();
    }
  }

  void _showBottomSheet() {
    setState(() { // disable the button
      _showBottomSheetCallback = null;
    });
    _bottomSheetController = _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      final ThemeData themeData = Theme.of(context);
      return AddActivity(themeData).getForm();
    });
    _bottomSheetController.closed.whenComplete(() {
      if (mounted) {
        setState(() { // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  ListView expansionList;
  Widget build(BuildContext context) {
    expansionList = ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].key.currentState.toggleExpanded();
                for(var i = 0; i < items.length; i++) {
                  if (i != index) {
                    items[i].key.currentState.isExpanded = false;
                  }
                }
              });
            },
            children: items.map((ActivityItem item) {
              return  ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return  ListTile(
                      leading: item.icon,
                      title:  Text(
                        item.header,
                        textAlign: TextAlign.left,
                        style:  TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ));
                },
                isExpanded: item.key.currentState != null ? item.key.currentState.isExpanded : false,
                body: item,
              );
            }).toList(),
          ),
        )
      ],
    );

    return MaterialApp(theme:  ThemeData.dark(),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text("Timehedron"),
            actions: <Widget>[
              PopupMenuButton<int>(itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<int>>[
                PopupMenuItem<int>(child: Text('Settings'), value: 0)
              ],
                  onSelected: (int result) {
                    setState(() {
                    });
                  })

            ]

        ),
        body: expansionList,
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleBottomSheet,
          child: _showBottomSheetCallback != null ? Icon(Icons.add) : Icon(Icons.remove),
          backgroundColor: _showBottomSheetCallback != null ? Colors.blueGrey : Colors.grey,
        ),
      )
    );
  }
}