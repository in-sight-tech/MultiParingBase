import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../models.dart';
import '../signals.dart';

class Imu extends SensorBase {
  ImuSettings? contents; // ImuSettings 타입의 contents 변수 선언

  Imu({
    required BluetoothDevice device, // BluetoothDevice 타입의 device 변수 선언
    Function(SensorBase)? dispose, // SensorBase 타입의 dispose 함수 선언
    Function(SensorBase, SignalBase)? onData, // SensorBase와 SignalBase 타입의 onData 함수 선언
  }) {
    super.device = device; // 상위 클래스의 device 변수에 매개변수로 받은 device 할당
    super.dispose = dispose; // 상위 클래스의 dispose 함수에 매개변수로 받은 dispose 함수 할당
    super.onData = onData; // 상위 클래스의 onData 함수에 매개변수로 받은 onData 함수 할당
  }

  @override
  void initConfig(json) {
    // initConfig 함수 오버라이딩
    samplingRate = json['sampling_rate'] as int; // json에서 'sampling_rate' 키의 값을 int 타입으로 가져와서 samplingRate 변수에 할당
    unit = json['unit'] as String == "m/s^2" ? 'm/s²' : json['unit'] as String; // json에서 'unit' 키의 값을 String 타입으로 가져와서 unit 변수에 할당. 만약 값이 "m/s^2"이면 "m/s²"로 변경
    contents = ImuSettings(json['rsw'] as int); // json에서 'rsw' 키의 값을 int 타입으로 가져와서 ImuSettings 클래스의 생성자에 전달하여 contents 변수에 할당
    bufferLength = 8 + contents!.getNumberOfActiveContent * 6; // bufferLength 변수에 8과 contents의 getNumberOfActiveContent 함수 반환값에 6을 곱한 값을 더한 값을 할당
  }

  @override
  void calSignal(ByteData bytes) async {
    // calSignal 함수 오버라이딩
    ImuSignal signal = ImuSignal(); // ImuSignal 타입의 signal 변수 선언 및 초기화
    int index = 6; // int 타입의 index 변수 선언 및 6으로 초기화

    biasTime ??= bytes.getInt16(2, Endian.big) * 1000 +
        bytes.getInt16(4, Endian.little); // biasTime이 null이면 bytes에서 2번째와 4번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값에 1000을 곱하고 더한 값을 할당

    signal.time = bytes.getInt16(2, Endian.big) * 1000 +
        bytes.getInt16(4, Endian.little) -
        biasTime!; // signal의 time 변수에 bytes에서 2번째와 4번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값에 1000을 곱하고 더한 값에서 biasTime을 뺀 값을 할당

    if (contents?.acceleration ?? false) {
      // 만약 contents의 acceleration이 true이면
      signal.ax = (bytes.getInt16(index, Endian.little) / 32768) *
          16; // signal의 ax 변수에 bytes에서 index번째와 index+1번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 16을 곱한 값을 할당
      signal.ay = (bytes.getInt16(index + 2, Endian.little) / 32768) *
          16; // signal의 ay 변수에 bytes에서 index+2번째와 index+3번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 16을 곱한 값을 할당
      signal.az = (bytes.getInt16(index + 4, Endian.little) / 32768) *
          16; // signal의 az 변수에 bytes에서 index+4번째와 index+5번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 16을 곱한 값을 할당

      if (unit == 'm/s²') {
        // 만약 unit이 "m/s²"이면
        signal.ax = signal.ax! * 9.80665; // signal의 ax 변수에 9.80665를 곱한 값을 할당
        signal.ay = signal.ay! * 9.80665; // signal의 ay 변수에 9.80665를 곱한 값을 할당
        signal.az = signal.az! * 9.80665; // signal의 az 변수에 9.80665를 곱한 값을 할당
      }

      index += 6; // index에 6을 더함
    }

    if (contents?.gyro ?? false) {
      // 만약 contents의 gyro가 true이면
      signal.wx = (bytes.getInt16(index, Endian.little) / 32768) *
          2000; // signal의 wx 변수에 bytes에서 index번째와 index+1번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 2000을 곱한 값을 할당
      signal.wy = (bytes.getInt16(index + 2, Endian.little) / 32768) *
          2000; // signal의 wy 변수에 bytes에서 index+2번째와 index+3번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 2000을 곱한 값을 할당
      signal.wz = (bytes.getInt16(index + 4, Endian.little) / 32768) *
          2000; // signal의 wz 변수에 bytes에서 index+4번째와 index+5번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 2000을 곱한 값을 할당

      index += 6; // index에 6을 더함
    }

    if (contents?.angle ?? false) {
      // 만약 contents의 angle이 true이면
      signal.roll = (bytes.getInt16(index, Endian.little) / 32768) *
          180; // signal의 roll 변수에 bytes에서 index번째와 index+1번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 180을 곱한 값을 할당
      signal.pitch = (bytes.getInt16(index + 2, Endian.little) / 32768) *
          180; // signal의 pitch 변수에 bytes에서 index+2번째와 index+3번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 180을 곱한 값을 할당
      signal.yaw = (bytes.getInt16(index + 4, Endian.little) / 32768) *
          180; // signal의 yaw 변수에 bytes에서 index+4번째와 index+5번째 바이트를 가져와서 Endian 방식에 맞게 int로 변환한 값을 32768로 나눈 후 180을 곱한 값을 할당
    }

    onData?.call(this, signal); // onData 함수 호출
  }

  void setReturnContent(ImuSettings rc) {
    // setReturnContent 함수 정의
    contents = rc; // contents 변수에 매개변수로 받은 rc 할당
    writeReg(data: '<src${contents!.config}>'); // writeReg 함수 호출

    bufferLength = 8 + contents!.getNumberOfActiveContent * 6; // bufferLength 변수에 8과 contents의 getNumberOfActiveContent 함수 반환값에 6을 곱한 값을 더한 값을 할당
  }
}

class ImuSettings {
  bool acceleration = true; // 가속도 센서 사용 여부
  bool gyro = false; // 자이로스코프 사용 여부
  bool angle = false; // 각도 센서 사용 여부

  ImuSettings(int rsw) {
    // 생성자
    acceleration = (rsw & 0x02) == 0x02; // 가속도 센서 사용 여부 설정
    gyro = (rsw & 0x04) == 0x04; // 자이로스코프 사용 여부 설정
    angle = (rsw & 0x08) == 0x08; // 각도 센서 사용 여부 설정
  }

  get config {
    // 설정값 반환
    int rsw = 0x01;

    if (acceleration) rsw |= 0x02; // 가속도 센서 사용 여부 설정
    if (gyro) rsw |= 0x04; // 자이로스코프 사용 여부 설정
    if (angle) rsw |= 0x08; // 각도 센서 사용 여부 설정

    return rsw; // 설정값 반환
  }

  List<String> units(String accUnit) {
    // 센서 단위 반환
    List<String> list = [];

    if (acceleration && accUnit == 'm/s²') {
      // 가속도 센서 사용 여부와 단위가 m/s²인 경우
      list.addAll(['m/s^2', 'm/s^2', 'm/s^2']); // x, y, z 축 가속도 센서 단위 설정
    } else if (acceleration && accUnit == 'g') {
      // 가속도 센서 사용 여부와 단위가 g인 경우
      list.addAll(['g', 'g', 'g']); // x, y, z 축 가속도 센서 단위 설정
    }

    if (gyro) list.addAll(['deg/s', 'deg/s', 'deg/s']); // 자이로스코프 사용 여부와 x, y, z 축 단위 설정
    if (angle) list.addAll(['deg', 'deg', 'deg']); // 각도 센서 사용 여부와 roll, pitch, yaw 축 단위 설정

    return list; // 센서 단위 반환
  }

  get names {
    // 센서 이름 반환
    List<String> list = [];

    if (acceleration) list.addAll(['acc.x', 'acc.y', 'acc.z']); // 가속도 센서 사용 여부와 x, y, z 축 이름 설정
    if (gyro) list.addAll(['wx', 'wy', 'wz']); // 자이로스코프 사용 여부와 x, y, z 축 이름 설정
    if (angle) list.addAll(['roll', 'pitch', 'yaw']); // 각도 센서 사용 여부와 roll, pitch, yaw 축 이름 설정

    return list; // 센서 이름 반환
  }

  int get getNumberOfActiveContent {
    // 활성화된 센서 개수 반환
    int count = 0;

    if (acceleration) count++; // 가속도 센서 사용 여부에 따라 count 증가
    if (gyro) count++; // 자이로스코프 사용 여부에 따라 count 증가
    if (angle) count++; // 각도 센서 사용 여부에 따라 count 증가

    return count; // 활성화된 센서 개수 반환
  }
}
