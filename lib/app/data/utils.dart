import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/collections/sensor_information.dart';
import 'package:multiparingbase/app/data/collections/sensor_signal.dart';

class Utils {
  static Future<Uint8List?> convertCSV(int count) async {
    Isar isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]);
    List<SensorInformation> informations = isar.sensorInformations.where().findAllSync();

    int? signalMinLength;
    for (SensorInformation information in informations) {
      signalMinLength ??= isar.sensorSignals.filter().sensorIdEqualTo(information.id).findAllSync().length;
      if (signalMinLength > isar.sensorSignals.filter().sensorIdEqualTo(information.id).findAllSync().length) {
        signalMinLength = isar.sensorSignals.filter().sensorIdEqualTo(information.id).findAllSync().length;
      }
    }

    List<List<String>> rows = [];

    rows.add(['#HEADER']);
    rows.add(['#TITLES']);
    rows.add(['', 'time']);
    rows.add(['#UNITS']);
    rows.add(['', 's']);
    rows.add(['#DATATYPES']);
    rows.add(['Huge', 'Float']);
    rows.add(['#DATA']);

    if (signalMinLength == null) {
      return null;
    }

    for (SensorInformation information in informations) {
      for (int i = 1; i < information.names.length; i++) {
        rows[2].add('${information.id}@${information.names[i]}');
        rows[4].add(information.units[i]);
        rows[6].add('Float');
      }

      List<SensorSignal> signal = isar.sensorSignals.filter().sensorIdEqualTo(information.id).findAllSync();
      for (int i = 0; i < signalMinLength; i++) {
        if (rows.length - 8 <= i) {
          rows.add(<String>['${i + 1}', ((signal[i].signals[0] ?? 0) / 1000).toStringAsFixed(3)]);
        }

        if (signal[i].signals.length == information.names.length) {
          for (int j = 1; j < information.names.length; j++) {
            rows[i + 8].add(signal[i].signals.elementAt(j)?.toStringAsFixed(3) ?? '');
          }
        } else {
          for (int j = 1; j < information.names.length; j++) {
            rows[i + 8].add('');
          }
        }
      }
    }

    String csvData = const ListToCsvConverter().convert(rows);

    Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));

    return bytes;
  }
}
