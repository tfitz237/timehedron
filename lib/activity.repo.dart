import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:timehedron_f/activity.item.dart';

class ActivitiesRepository {
  List<ActivityItem> _activities;

  ActivitiesRepository();

  getAll() async {
    var contents = await readFromFile();
    if (contents == null) {
      return List<ActivityItem>();
    }
    _activities = (contents['activities'] as List).map((e) => ActivityItem.fromJson(e)).toList();
    return _activities;
  }


  saveAll() {
    writeToFile(json.encode(_activities.map((e) => e.toJson())));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/activities.json');
  }

  Future<File> writeToFile(String content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(content);
  }

  Future<Map<String,dynamic>> readFromFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If we encounter an error, return 0
      await writeToFile('{"activities":[    {      \"header\": \"Advice\",      \"iconString\": \"access_time\",\"checkIns\": [] }]}');
      return  null;
    }
  }




}