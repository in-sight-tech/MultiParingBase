import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future<bool> toCSV() async {
    List<String> header = [];

    List<List<String>> rows = [];

    header.addAll(['time', 'acc.x', 'acc.y', 'acc.z']);
    rows.add(['time', 'acc.x', 'acc.y', 'acc.z']);
    for (int i = 0; i < 1000000; i++) {
      rows.add([i.toString(), '0', '0', '1']);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    DateTime now = DateTime.now();
    String formattedData = DateFormat('yyyyMMddHHmmss').format(now);

    final bytes = utf8.encode(csvData);
    Uint8List bytes2 = Uint8List.fromList(bytes);
    MimeType type = MimeType.CSV;
    await FileSaver.instance.saveAs('$formattedData.csv', bytes2, 'csv', type);
    return true;
  }
}
