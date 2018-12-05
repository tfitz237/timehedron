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
      appBar: AppBar(
        title: Text("Timehedron"),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) =>
            <PopupMenuEntry>[
              PopupMenuItem(child: Text('Settings'))
            ]
            )

        ]

      ),
      body: List_Criteria,
//      persistentFooterButtons: <Widget>[
//         ButtonBar(children: <Widget>[
//           FlatButton(
//            color: Colors.blue,
//            onPressed: null,
//            child:  Text(
//              'Apply',
//              textAlign: TextAlign.left,
//              style:  TextStyle(fontWeight: FontWeight.bold),
//            ),
//          )
//        ])
//      ],
    );
    return MaterialApp(home: scaffold, theme:  ThemeData.dark());
  }
}