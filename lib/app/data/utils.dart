import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'collections/sensor_information.dart';
import 'collections/sensor_signal.dart';

class Utils {
  static Future<Uint8List?> toCSV(int count) async {
    Isar isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]); // Isar 데이터베이스 열기
    List<SensorInformation> informations = isar.sensorInformations.where().findAllSync(); // SensorInformation 테이블에서 모든 데이터 가져오기

    int? signalMinLength; // 신호 데이터 중 가장 짧은 길이

    for (SensorInformation information in informations) {
      // 모든 SensorInformation 데이터에 대해 반복
      signalMinLength ??= isar.sensorSignals.filter().sensorIdEqualTo(information.id).countSync(); // signalMinLength가 null일 경우, 해당 센서의 신호 데이터 길이로 초기화
      if (signalMinLength > isar.sensorSignals.filter().sensorIdEqualTo(information.id).countSync()) {
        // 해당 센서의 신호 데이터 길이가 signalMinLength보다 작을 경우, signalMinLength를 해당 길이로 업데이트
        signalMinLength = isar.sensorSignals.filter().sensorIdEqualTo(information.id).countSync();
      }
    }

    List<List<String>> rows = []; // CSV 파일의 행 데이터를 저장할 리스트

    int columnIndex = 1; // CSV 파일에서 데이터가 시작되는 열 인덱스

    // 헤더를 나타내는 문자열을 추가합니다.
    rows.add(['#HEADER']);
    // 제목을 나타내는 문자열을 추가합니다.
    rows.add(['#TITLES']);
    // 빈 줄을 추가합니다.
    rows.add(['']);
    // 샘플링 속도를 나타내는 문자열을 추가합니다.
    rows.add(['#SAMPLINGRATE']);
    // 빈 줄을 추가합니다.
    rows.add(['']);
    // 단위를 나타내는 문자열을 추가합니다.
    rows.add(['#UNITS']);
    // 빈 줄을 추가합니다.
    rows.add(['']);
    // 데이터 유형을 나타내는 문자열을 추가합니다.
    rows.add(['#DATATYPES']);
    // Huge 문자열을 추가합니다.
    rows.add(['Huge']);
    // 데이터를 나타내는 문자열을 추가합니다.
    rows.add(['#DATA']);

    if (signalMinLength == null) {
      // 신호 데이터가 없을 경우, null 반환
      return null;
    }

    for (SensorInformation information in informations) {
      // 모든 SensorInformation 데이터에 대해 반복
      /// Metadata 삽입
      for (int i = 0; i < information.names.length; i++) {
        // 해당 센서의 모든 신호에 대해 반복
        rows[0].add(''); // 헤더 부분에 빈 칼럼 삽입
        rows[1].add(''); // 칼럼 제목 부분에 빈 칼럼 삽입
        rows[2].add('${information.deviceName}@${information.names[i]}'); // 칼럼 제목 삽입
        rows[3].add(''); // 칼럼 단위 부분에 빈 칼럼 삽입
        rows[4].add('200'); // 샘플링 레이트 삽입
        rows[5].add(''); // 데이터 타입 부분에 빈 칼럼 삽입
        rows[6].add(information.units[i]); // 칼럼 단위 삽입
        rows[8].add('Float'); // 데이터 타입 삽입
        rows[9].add(''); // 데이터 부분에 빈 칼럼 삽입
      }

      /// 신호 데이터 가져오기
      List<SensorSignal> signal = isar.sensorSignals.filter().sensorIdEqualTo(information.id).findAllSync(); // 해당 센서의 모든 신호 데이터 가져오기

      for (int i = 0; i < signal.length; i++) {
        // 해당 센서의 모든 신호 데이터에 대해 반복
        /// 첫 번째 칼럼에 index 삽입
        if (rows.length - 10 <= i) {
          // 행 데이터가 부족할 경우, 새로운 행 데이터 생성
          rows.add(<String>['${i + 1}']);
        }

        while (rows[i + 10].length < columnIndex) {
          // 해당 신호 데이터의 길이가 columnIndex보다 작을 경우, 빈 칼럼 삽입
          rows[i + 10].add('');
        }

        if (signal[i].signals.length == information.names.length) {
          // 해당 신호 데이터의 길이가 센서의 신호 개수와 같을 경우, 모든 신호 데이터 삽입
          for (int j = 0; j < information.names.length; j++) {
            rows[i + 10].add(signal[i].signals.elementAt(j)?.toStringAsFixed(3) ?? ''); // 해당 신호 데이터 삽입
          }
        } else {
          // 해당 신호 데이터의 길이가 센서의 신호 개수와 다를 경우, 빈 칼럼 삽입
          for (int j = 1; j < information.names.length; j++) {
            rows[i + 10].add('');
          }
        }
      }

      columnIndex += information.names.length; // columnIndex 업데이트
    }

    String csvData = const ListToCsvConverter().convert(rows); // rows 리스트를 CSV 파일 형식으로 변환

    Uint8List bytes = Uint8List.fromList(utf8.encode(csvData)); // CSV 파일을 바이트 형식으로 변환

    return bytes; // 바이트 형식의 CSV 파일 반환
  }
}
