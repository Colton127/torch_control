import 'dart:async';

import 'package:flutter/services.dart';

class TorchControl {
  static const MethodChannel _channel = MethodChannel('torch_control');

  /// Is the flashlight available?
  static Future<bool> ready() async {
    return await _channel.invokeMethod('ready');
  }

  static bool _isOn = false;

  static bool _isLocked = false;

  static bool get isLocked => _isLocked;

  /// Is the flashlight on?
  static bool get isOn => _isOn;

  /// Is the flashlight off?
  static bool get isOff => !_isOn;

  /// Turn the flashlight on or off.
  static Future<bool> turn(bool state, {double torchLevel = 1.0}) async {
    _isOn = await _channel.invokeMethod('turn', {'state': state, 'torchLevel': torchLevel});
    return _isOn;
  }

  static Future<bool> loop(double frequency, {double torchLevel = 1.0}) async {
    double getTime = (((1000 / frequency / 2) * 1000) / 1000000);
    _isOn = await _channel.invokeMethod('loop', {'time': getTime, 'torchLevel': torchLevel});
    return _isOn;
  }

  static Future<void> cancelLoop() async {
    _isOn = await _channel.invokeMethod('stoploop');
  }

//iOS Devices: Calls lockForConfiguration. Required for torch to work. Call this in advance to save performance during strobe.
  static Future<bool> deviceLock(bool lock) async {
    _isLocked = await _channel.invokeMethod('lock', {'lock': lock});
    return _isLocked;
  }

  /// Turn the flashlight on.
  static Future<bool> turnOn() async => turn(true);

  /// Turn the flashlight off.
  static Future<bool> turnOff() async => turn(false);

  /// Toggle the flashlight (on goes to off and vice versa).
  static Future<bool> toggle() async => turn(!isOn);

  /// Flash the flashlight for the specified duration.
  static Future<void> flash(Duration duration) => turnOn().whenComplete(() => Future.delayed(duration, turnOff));
}
