import Flutter
import UIKit
import AVFoundation

public class SwiftTorchControlPlugin: NSObject, FlutterPlugin {
    var timer = Timer()
    var isLoopOn : Bool = false
    var torchLevel : Float = 1.0
    let device = AVCaptureDevice.default(for: .video)
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "torch_control", binaryMessenger: registrar.messenger())
        let instance = SwiftTorchControlPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "turn") {
            let state = ((call.arguments as! [String: Any])["state"]) as! Bool;
            let torchLevel = (((call.arguments as! [String: Any])["torchLevel"]) as! NSNumber).floatValue; 

            result(turn(state: state, torchLevel: torchLevel) )
        } else if (call.method == "ready"){
            result(hasTorch() )
              } else if (call.method == "lock"){
              let lock = ((call.arguments as! [String: Any])["lock"]) as! Bool;


                   } else if (call.method == "loop"){
                     lockDeviceConfiguration(lock: true)
                       timer.invalidate()
                                let time = (((call.arguments as! [String: Any])["time"]) as! Double);
            torchLevel = (((call.arguments as! [String: Any])["torchLevel"]) as! NSNumber).floatValue;
                       timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)


                    } else if (call.method == "stoploop"){
                        timer.invalidate()
        }else{
            result(FlutterMethodNotImplemented)
    }
    }
    @objc func timerAction() {
        
       do {
        if (isLoopOn){
device!.torchMode = .off
isLoopOn = false
        }else{
if (torchLevel == 1.0){
                try device!.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }else{
                try device!.setTorchModeOn(level: torchLevel)
            }
            isLoopOn = true
        }

        }catch{
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
      try device.lockForConfiguration()
        }else{
            device.unlockForConfiguration()
        }
        return true
         }catch{
return false
      }
    }
        

    func turn(state: Bool, torchLevel: Float) -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        do {
        if (state == true){
            if (torchLevel == 1.0){
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }else{
                try device.setTorchModeOn(level: torchLevel)
            }
        }else{
            device.torchMode = .off
        }
        }catch{
return false
     }
        return state
            
    }
}
