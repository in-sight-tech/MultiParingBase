import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Analog extends SensorBase {
  num displacement1 = 0; // 변위 1
  num displacement2 = 0; // 변위 2
  num inputSignal1 = 0; // 입력 신호 1
  num inputSignal2 = 0; // 입력 신호 2
  bool mode = false; // 모드
  num calValue = 1.0; // 보정 값

  Analog({
    required BluetoothDevice device, // 블루투스 디바이스
    Function(SensorBase)? dispose, // 센서 해제 함수
    Function(SensorBase, SignalBase)? onData, // 데이터 수신 함수
  }) {
    super.device = device;
    super.dispose = dispose;
    super.onData = onData;
    bufferLength = 12; // 버퍼 길이
  }

  @override
  void initConfig(json) {
    mode = json['mode'] == '5v' ? false : true; // 모드 설정
    unit = json['unit'] as String; // 단위 설정
    calValue = json['cal_value']; // 보정 값 설정
    samplingRate = json['sampling_rate'] as int; // 샘플링 레이트 설정
    displacement1 = json['displacement1']; // 변위 1 설정
    displacement2 = json['displacement2']; // 변위 2 설정
    inputSignal1 = json['input_signal1']; // 입력 신호 1 설정
    inputSignal2 = json['input_signal2']; // 입력 신호 2 설정
  }

  @override
  void calSignal(ByteData bytes) async {
    AnalogSignal signal = AnalogSignal(); // 아날로그 신호 객체 생성

    biasTime ??= bytes.getUint32(2, Endian.little); // 바이어스 타임 설정
    signal.time = bytes.getUint32(2, Endian.little) - biasTime!; // 시간 설정

    signal.value = bytes.getFloat32(6, Endian.little); // 값 설정

    onData?.call(this, signal); // 데이터 수신
  }

  void setMode(String mode) {
    // 모드 설정 함수
    writeReg(data: '<sm$mode>'); // 레지스터에 모드 설정
  }

  void setDisplacement1(double value) {
    // 변위 1 설정 함수
    writeReg(data: '<dis1$value>'); // 레지스터에 변위 1 설정
  }

  void setDisplacement2(double value) {
    // 변위 2 설정 함수
    writeReg(data: '<dis2$value>'); // 레지스터에 변위 2 설정
  }

  void setImputSignal1(double value) {
    // 입력 신호 1 설정 함수
    writeReg(data: '<is1$value>'); // 레지스터에 입력 신호 1 설정
  }

  void setImputSignal2(double value) {
    // 입력 신호 2 설정 함수
    writeReg(data: '<is2$value>'); // 레지스터에 입력 신호 2 설정
  }
}
