import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/collections/sensor_information.dart';
import 'package:multiparingbase/app/data/collections/sensor_signal.dart';

class Utils {
  static Future<Uint8List?> convertCSV(int count) async {
    Isar isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]);
    int sensorCounts = isar.sensorInformations.countSync();

    // for (int i = 0; i < sensorCounts; i++) {}

    // int? isarMinLength;
    // for (Isar isar in isars) {
    //   isarMinLength ??= isar.data9Axis.countSync();
    //   if (isarMinLength > isar.data9Axis.countSync()) {
    //     isarMinLength = isar.data9Axis.countSync();
    //   }
    // }

    List<List<String>> rows = [];

    rows.add(['#HEADER']);
    rows.add(['#TITLES']);
    rows.add(['']);
    rows.add(['#UNITS']);
    rows.add(['']);
    rows.add(['#DATATYPES']);
    rows.add(['Huge']);
    rows.add(['#DATA']);

    // if (isarMinLength == null) {
    //   return null;
    // }

    // for (Isar isar in isars) {
    //   rows[2].addAll(['', isar.name]);
    //   rows[4].addAll(['s', 'mm']);
    //   rows[6].addAll(['Double', 'Float']);
    //   for (int i = 0; i < isarMinLength; i++) {
    //     if (rows.length - 8 <= i) {
    //       rows.add(<String>['${i + 1}']);
    //     }
    //     rows[i + 8].addAll([((isar.data9Axis.getSync(i + 1)!.time! / 1000).toStringAsFixed(3))]);
    //   }
    // }

    String csvData = const ListToCsvConverter().convert(rows);

    Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));

    return bytes;
  }
}
