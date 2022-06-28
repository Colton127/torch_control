import Flutter
import UIKit
import AVFoundation

public class SwiftTorchControlPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "torch_control", binaryMessenger: registrar.messenger())
        let instance = SwiftTorchControlPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "turn") {
            let state = ((call.arguments as! [String: Any])["state"]) as! Bool;

            result(turn(state: state) )
        } else if (call.method == "ready"){
            result(hasTorch() )
              } else if (call.method == "lock"){
              let lock = ((call.arguments as! [String: Any])["lock"]) as! Bool;

            result(lockDeviceConfiguration(lock: lock) )
        }else{
            result(FlutterMethodNotImplemented)
    }
    }

    func hasTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.hasFlash && device.hasTorch
    }

    func lockDeviceConfiguration(lock: Bool) -> Bool{
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
      
      do {
 if (lock == true){
      try  device.lockForConfiguration()
        }else{
           try device.unlockForConfiguration()
        }
        return true
         }catch{
return false
      }
    }

    func turn(state: Bool) -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        device.torchMode = state ? .on : .off
        return state
    }
}
