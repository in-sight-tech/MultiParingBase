// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart' as log;

import 'package:intl/intl.dart';

import '../signals.dart';

abstract class SensorBase {
  // BLE 특성 UUID 값들을 상수로 정의
  static const CHARACTERISTIC_UUID_WRITE = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_NOTIFY = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_CONFIG = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E";

// BluetoothDevice, BluetoothService, BluetoothCharacteristic, StreamSubscription, Queue, log.Logger 등의 변수들을 선언
  late BluetoothDevice device; // 늦은 초기화를 사용하여 나중에 초기화
  BluetoothService? service; // nullable 변수
  BluetoothCharacteristic? writeCharacteristic; // nullable 변수
  BluetoothCharacteristic? notifyCharacteristic; // nullable 변수
  BluetoothCharacteristic? configCharacteristic; // nullable 변수

  StreamSubscription? configStream; // nullable 변수
  StreamSubscription? notifyStream; // nullable 변수
  StreamSubscription? deviceStateStream; // nullable 변수

  String jsonBuffer = ''; // 빈 문자열로 초기화
  Queue<int> buffer = Queue<int>(); // Queue 객체 생성
  int? bufferLength; // nullable 변수

  log.Logger logger = log.Logger(); // log.Logger 객체 생성

  String unit = 'v'; // 문자열 변수 unit을 'v'로 초기화
  int samplingRate = 200; // 정수형 변수 samplingRate를 200으로 초기화
  int? biasTime; // nullable 변수

// onData 함수와 dispose 함수를 받아들이는 함수를 선언
// SensorBase와 SignalBase를 매개변수로 받는 onData 함수는 nullable
// SensorBase를 매개변수로 받는 dispose 함수는 nullable
  Function(SensorBase, SignalBase)? onData;
  Function(SensorBase)? dispose;
// Bluetooth 연결 함수
  Future<bool> connect() async {
    try {
      // Bluetooth 장치와 연결 시도
      await device.connect(timeout: const Duration(seconds: 4), autoConnect: false);

      // Bluetooth 장치 상태를 모니터링하는 Stream 생성
      deviceStateStream = device.state.listen((event) {
        // Bluetooth 장치가 연결이 끊어지면 disconnect 함수 호출
        if (event == BluetoothDeviceState.disconnected) {
          disconnect();
        }
      });

      // Bluetooth 장치에서 제공하는 서비스들을 검색
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        // 검색된 서비스 중 Nordic UART Service를 찾음
        if (service.uuid == Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) {
          this.service = service;
        }
      }

      // Nordic UART Service를 찾지 못하면 연결 실패
      if (service == null) {
        return false;
      }

      // Nordic UART Service에서 제공하는 Characteristic들을 검색
      List<BluetoothCharacteristic> characteristics = service!.characteristics;
      for (var characteristic in characteristics) {
        // 검색된 Characteristic 중 Write Characteristic를 찾음
        if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_WRITE)) {
          writeCharacteristic = characteristic;
        }
        // 검색된 Characteristic 중 Notify Characteristic를 찾음
        else if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_NOTIFY)) {
          notifyCharacteristic = characteristic;
        }
        // 검색된 Characteristic 중 Config Characteristic를 찾음
        else if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_CONFIG)) {
          configCharacteristic = characteristic;
        }
      }
      // Config Characteristic을 연결
      connectConfigChracteristic();

      // 연결 성공
      return true;
    } catch (e) {
      // 연결 실패
      logger.e(e);
      return false;
    }
  }

  void disconnect() {
    try {
      // notifyCharacteristic의 notifyValue를 false로 설정하여 알림을 중지한다.
      notifyCharacteristic!.setNotifyValue(false);
      // notifyStream을 취소한다.
      notifyStream?.cancel();
      // deviceStateStream을 취소한다.
      deviceStateStream?.cancel();
      // device와 연결을 끊는다.
      device.disconnect();
      // dispose 함수를 호출하여 자원을 해제한다.
      dispose?.call(this);
    } catch (e) {
      // 예외가 발생하면 로그를 출력한다.
      logger.e(e);
    }
  }

  void start() {
    // biasTime 변수를 null로 초기화합니다.
    biasTime = null;
    // 현재 시간을 'yyyyMMddHHmmss' 형식으로 포맷팅하여 문자열로 변환한 뒤, '<si'와 '>' 문자열을 추가하여 writeReg() 함수에 전달합니다.
    writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');
  }

  // '<eoi>' 데이터를 writeReg 함수에 전달하여 전송하는 stop 함수
  // stop 함수는 '<eoi>' 데이터를 writeReg 함수에 전달하여 전송하는 함수입니다.
  void stop() => writeReg(data: '<eoi>');

  // calSignal 함수는 ByteData 형식의 bytes 매개변수를 받아들이는 함수입니다.
  void calSignal(ByteData bytes);

  // setSamplingRate 함수는 int 형식의 samplingRate 매개변수를 받아들이는 함수입니다.
  // 함수 내부에서는 '<sor$samplingRate>' 데이터를 writeReg 함수에 전달하여 전송합니다.
  void setSamplingRate(int samplingRate) => writeReg(data: '<sor$samplingRate>');

  // setName 함수는 String 형식의 name 매개변수를 받아들이는 함수입니다.
  // 함수 내부에서는 '<sn$name>' 데이터를 writeReg 함수에 전달하여 전송합니다.
  void setName(String name) => writeReg(data: '<sn$name>');

  // calibrate 함수는 '<zc>' 데이터를 writeReg 함수에 전달하여 전송하는 함수입니다.
  void calibrate() => writeReg(data: '<zc>');

  // setCalibrationValue 함수는 double 형식의 value 매개변수를 받아들이는 함수입니다.
  // 함수 내부에서는 '<cv$value>' 데이터를 writeReg 함수에 전달하여 전송합니다.
  void setCalibrationValue(double value) => writeReg(data: '<cv$value>');

  // setUnit 함수는 String 형식의 unit 매개변수를 받아들이는 함수입니다.
  // 함수 내부에서는 '<su$unit>' 데이터를 writeReg 함수에 전달하여 전송합니다.
  void setUnit(String unit) => writeReg(data: '<su$unit>');

  // '<rc>' 데이터를 포함하여 writeReg 함수를 호출합니다.
  void requestConfig() => writeReg(data: '<rc>');

  Future<void> writeReg({required String data, int delayMs = 0}) async {
    // 비동기 함수 writeReg 선언, data 매개변수는 필수, delayMs는 0으로 초기화
    if (writeCharacteristic == null) return; // writeCharacteristic가 null이면 함수 종료
    writeCharacteristic?.write(data.codeUnits); // writeCharacteristic가 null이 아니면 data를 codeUnits로 변환하여 write() 함수 호출
    await Future.delayed(Duration(milliseconds: delayMs)); // delayMs 시간만큼 대기
  }

// 바이트 데이터 패킷이 유효한지 확인하는 함수
  bool isValiable(ByteData packets) {
    // 패킷의 길이가 0이면 유효하지 않음
    if (packets.lengthInBytes == 0) return false;
    // 체크섬 초기값 설정
    int checksum = 0x00;

    // 패킷의 길이에서 마지막 2바이트를 제외한 길이만큼 반복
    for (int i = 0; i < packets.lengthInBytes - 2; i++) {
      // 체크섬 계산
      checksum = (checksum + packets.getUint8(i)) & 0xffff;
    }

    // 계산된 체크섬 값과 패킷의 마지막 2바이트 값을 비교하여 유효성 검사 결과 반환
    return checksum == packets.getUint16(bufferLength! - 2, Endian.little);
  }

// initConfig 함수 선언, Map<String, dynamic> 타입의 json 파라미터를 받음
  void initConfig(Map<String, dynamic> json);
// configCharacteristic가 null이 아닌 경우
  void connectConfigChracteristic() {
    if (configCharacteristic != null) {
      // configCharacteristic의 NotifyValue를 true로 설정
      configCharacteristic!.setNotifyValue(true);
      // configCharacteristic의 value를 구독하고, event가 발생할 때마다 실행되는 콜백 함수 정의
      configStream = configCharacteristic!.value.listen((event) {
        // event의 각 unit에 대해 반복문 실행
        for (var unit in event) {
          // jsonBuffer에 unit을 문자열로 변환하여 추가
          jsonBuffer += String.fromCharCode(unit);
          // unit이 '}'인 경우
          if (String.fromCharCode(unit) == '}') {
            // jsonBuffer를 JSON 형식으로 디코딩하여 initConfig 함수 실행
            initConfig(jsonDecode(jsonBuffer));
            // jsonBuffer 초기화
            jsonBuffer = '';
            // connectNotifyCharacteristic 함수 실행
            connectNotifyCharacteristic();
          }
        }
      });
      // 300ms 후 requestConfig 함수 실행
      Future.delayed(const Duration(milliseconds: 300)).then((value) => requestConfig());
    }
  }

// notifyCharacteristic와 configCharacteristic가 null이 아닐 때, notifyCharacteristic의 notifyValue를 true로 설정하고, notifyStream을 생성한다.
  void connectNotifyCharacteristic() async {
    configCharacteristic!.setNotifyValue(false); // configCharacteristic의 notifyValue를 false로 설정한다.
    configStream?.cancel(); // configStream이 null이 아닐 때, cancel() 메소드를 호출하여 스트림을 종료한다.

    await Future.delayed(const Duration(milliseconds: 300)); // 300밀리초 동안 대기한다.

    if (notifyCharacteristic != null) {
      // notifyCharacteristic가 null이 아닐 때,
      notifyCharacteristic!.setNotifyValue(true); // notifyCharacteristic의 notifyValue를 true로 설정한다.
      notifyStream = notifyCharacteristic!.value.listen((event) {
        // notifyCharacteristic의 value 스트림을 구독하고, 이벤트가 발생할 때마다 실행된다.
        if (bufferLength == null) return; // bufferLength가 null일 때, 함수를 종료한다.
        for (int byte in event) {
          // event에서 byte를 하나씩 꺼내어 반복한다.
          while (buffer.length >= bufferLength!) {
            // buffer의 길이가 bufferLength 이상일 때,
            if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
              // buffer의 첫 번째와 두 번째 요소가 0x55일 때,
              if (isValiable(ByteData.view(Uint8List.fromList(buffer.toList()).buffer))) {
                // buffer를 ByteData로 변환하여 isValiable 함수에 전달하고, true를 반환할 때,
                calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer)); // buffer를 ByteData로 변환하여 calSignal 함수에 전달한다.
                buffer.clear(); // buffer를 비운다.
              } else {
                // isValiable 함수가 false를 반환할 때,
                buffer.removeFirst(); // buffer의 첫 번째 요소를 제거한다.
              }
            } else {
              // buffer의 첫 번째와 두 번째 요소가 0x55가 아닐 때,
              buffer.removeFirst(); // buffer의 첫 번째 요소를 제거한다.
            }
          }

          buffer.add(byte); // byte를 buffer에 추가한다.
        }
      });
    }
  }
}
