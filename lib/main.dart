import 'package:flutter/material.dart';

void main() => runApp(Criterias());



class Criterias extends StatefulWidget {
  CriteriaState createState() =>  CriteriaState();
}

class ActivityItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  ActivityItem(this.isExpanded, this.header, this.body, this.iconpic);
}


class CriteriaState extends State<Criterias> {


  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ActivityItem> items = <ActivityItem>[
     ActivityItem(
        false,
        'Advice',
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(padding: EdgeInsets.all(10.0),
                          child: Text('hello')),
                      Padding(padding: EdgeInsets.all(10.0), child: Text('hello 2')),
                      Padding(padding: EdgeInsets.all(10.0), child: Text('hello 3'))
                  ],),

                ])
        ),
        Icon(Icons.access_time),
    ),
    ActivityItem(
      false,
      'Meetings',
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10.0), child: Text('hello 3'))
              ])
      ),
      Icon(Icons.access_alarm),
    )
    //give all your items here
  ];

  VoidCallback _showBottomSheetCallback;

  PersistentBottomSheetController _bottomSheetController;
  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
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
      return Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: themeData.disabledColor))
          ),
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeData.accentColor,
                      fontSize: 24.0
                  )
              )
          )
      );
    });
    _bottomSheetController.closed.whenComplete(() {
      if (mounted) {
        setState(() { // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  ListView List_Criteria;
  Widget build(BuildContext context) {
    List_Criteria = ListView(
      children: [
        Padding(padding:  EdgeInsets.all(10.0), child: Center(child: Text('Activities', style:  TextStyle(fontSize: 20.0)),)),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].isExpanded = !items[index].isExpanded;
                for(var i = 0; i < items.length; i++) {
                  if (i != index) {
                    items[i].isExpanded = false;
                  }
                }
              });
            },
            children: items.map((ActivityItem item) {
              return  ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return  ListTile(
                      leading: item.iconpic,
                      title:  Text(
                        item.header,
                        textAlign: TextAlign.left,
                        style:  TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ));
                },
                isExpanded: item.isExpanded,
                body: item.body,
              );
            }).toList(),
          ),
        )
      ],
    );

    Scaffold scaffold =  Scaffold(
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
      body: List_Criteria,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleBottomSheet,
        child: _showBottomSheetCallback != null ? Icon(Icons.add) : Icon(Icons.remove),
        backgroundColor: _showBottomSheetCallback != null ? Colors.blueGrey : Colors.grey,
      ),
    );
    return MaterialApp(home: scaffold, theme:  ThemeData.dark());
  }
}