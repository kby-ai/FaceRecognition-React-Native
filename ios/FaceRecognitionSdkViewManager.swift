// import AVFoundation

// @objc(FaceRecognitionSdkViewManager)
// class FaceRecognitionSdkViewManager: RCTViewManager {
//     @objc static var faceRecognitionView: FaceRecognitionSdkView? = nil
    
//     override func view() -> (FaceRecognitionSdkView) {
//         FaceRecognitionSdkViewManager.faceRecognitionView = FaceRecognitionSdkView()
//         return FaceRecognitionSdkViewManager.faceRecognitionView!
//     }
    
//     @objc override static func requiresMainQueueSetup() -> Bool {
//         return false
//     }
    
//     @objc static func startCamera() {
//         print("kkkk start camera")
//     }
    
//     @objc static func stopCamera() {
//         print("kkkk stop camera")
//     }
// }

// @objc(FaceRecognitionSdkView)
// class FaceRecognitionSdkView : UIView {

// //  let frame: CGRect
//   let captureSession = AVCaptureSession()

//   var cameraLens: AVCaptureDevice.Position!
//   var cameraRunning: Bool = false
//   var cameraViewInited: Bool = false
//   var startTime: Double = 0

//   var cameraView : UIView!
//   let dummyLayout = CAShapeLayer()

//     override init(frame: CGRect) {
//         super.init(frame: frame)
//         print("Face recognition view initialized! frame: ", frame)
        
//         self.cameraView = UIView(frame: frame)
//     }
    
//     required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)

//         print("Face recognition view initialized 111!")
//     }
    
//     func startCamera() {
        
//     }
    
//     func stopCamera() {
        
//     }

//   // @objc var color: String = "" {
//   //   didSet {
//   //     self.backgroundColor = hexStringToUIColor(hexColor: color)
//   //   }
//   // }

//   // func hexStringToUIColor(hexColor: String) -> UIColor {
//   //   let stringScanner = Scanner(string: hexColor)

//   //   if(hexColor.hasPrefix("#")) {
//   //     stringScanner.scanLocation = 1
//   //   }
//   //   var color: UInt32 = 0
//   //   stringScanner.scanHexInt32(&color)

//   //   let r = CGFloat(Int(color >> 16) & 0x000000FF)
//   //   let g = CGFloat(Int(color >> 8) & 0x000000FF)
//   //   let b = CGFloat(Int(color) & 0x000000FF)

//   //   return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
//   // }
// }
