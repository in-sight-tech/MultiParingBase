import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future<bool> toCSV(Map<String, dynamic> args) async {
    List<List<String>> rows = [];

    rows.add(['#HEADER']);
    rows.add(['#TITLES']);
    rows.add(['']);
    rows.add(['#UNITS']);
    rows.add(['']);
    rows.add(['#DATATYPES']);
    rows.add(['Huge']);
    rows.add(['#DATA']);

    rows.add(['time', 'acc.x', 'acc.y', 'acc.z']);
    for (int i = 0; i < 1000000; i++) {
      rows.add([i.toString(), '0', '0', '1']);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    DateTime now = DateTime.now();
    String formattedData = DateFormat('yyyyMMddHHmmss').format(now);

    Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
    MimeType type = MimeType.CSV;
    await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
    return true;
  }
}
