import 'package:flutter/material.dart';

class AddActivity {
  ThemeData themeData;

  AddActivity(this.themeData);
  getForm() {
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
  }
}