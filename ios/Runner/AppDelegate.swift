import UIKit
import Flutter
import AdSupport

import AVFoundation
import MobileCoreServices
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = -1;
    
    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    let bgImageV = UIImageView(image: UIImage(named: "loadinglogo"))
    bgImageV.contentMode = .scaleAspectFill
    bgImageV.frame = UIScreen.main.bounds
    window.addSubview(bgImageV)
    
    let vc:FlutterViewController = self.window.rootViewController as! FlutterViewController;
    let eventChannel = FlutterMethodChannel.init(name: "com.yinse/device", binaryMessenger: vc.binaryMessenger)
    eventChannel.setMethodCallHandler { (call, result) in
        if(call.method == "getDeviceId") {
            result(self.localUUID);
            return
        }
        
        
        
        // ==================往下是：视频接口区域==================
        guard let data = call.arguments,
            let args = data as? NSDictionary else {
                result(0)
            return
        }
        guard let path = args["filePath"] as? String else {
            result(0)
            return
        }
        
        if(call.method == "getVideoDuration") {
            result(self.getVideoDuration(path));
        }else if(call.method == "getVideoResolution") {
            result(self.getVideoResolution(path));
        }else if(call.method == "getVideoRatio") {
            result(self.getVideoRatio(path));
        }else if(call.method == "getVideoSize") {
            result(self.getVideoSize(path));
        }else if(call.method == "saveCoverInLocal") {
            result(self.saveCoverInLocal(path));
        }else if(call.method == "getVideoBitrate") {
            result(self.getVideoBitrate(path));
        }
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    ///本地-UUID
    public var localUUID: String {
        let key:String = BCSKeyChainTool.load(service: "com.yinseplayerx.one")
        if key.count > 0 && key != "" {
            return key
        }
        var saveKey = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if saveKey.contains("00000000-0000-0000-0000-000000000000"){
            saveKey = NSUUID().uuidString;
        }
        BCSKeyChainTool.save(service: "com.yinseplayerx.one", data: saveKey as Any)
        return saveKey;
    }
    
    //=============================
    
    ///时长
    public func getVideoDuration(_ path :String?) -> Int {
        if(path == nil || path == "") {
            return 0
        }
        let videoURL = NSURL(fileURLWithPath: path!)
        let duration = AVURLAsset(url: videoURL as URL).duration.seconds
        return Int(duration)
    }
    
    ///分辨率
    public func getVideoResolution(_ path :String?) -> String {//获取本地视频
        if(path == nil || path == "") {
            return ""
        }
        let videoURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: videoURL as URL)
        let tracks = avAsset.tracks(withMediaType: AVMediaType.video)//(withMediaType: AVMediaType.mediaType)
        if(tracks.count > 0){
            let videoTrack = tracks[0]
            let str = "\(Int(videoTrack.naturalSize.width))*\(Int(videoTrack.naturalSize.height))"
            return str;
        }
        return ""
        
    }
    
    ///宽高比
    public func getVideoRatio(_ path :String?) -> String {
        if(path == nil || path == "") {
            return ""
        }
        let videoURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: videoURL as URL)
        let tracks = avAsset.tracks(withMediaType: AVMediaType.video)//(withMediaType: AVMediaType.mediaType)
        if(tracks.count > 0){
            let videoTrack = tracks[0]
            let str = "\(videoTrack.naturalSize.width/videoTrack.naturalSize.height)"
            return str;
        }
        return "";
    }
    
    public func getVideoBitrate(_ path :String?) -> String {
        if(path == nil || path == "") {
            return ""
        }
        let videoURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: videoURL as URL)
        let tracks = avAsset.tracks(withMediaType: AVMediaType.video)//(withMediaType: AVMediaType.mediaType)
        if(tracks.count > 0){
            let videoTrack = tracks[0]
            let rate = videoTrack.estimatedDataRate
            return "\(rate)";
        }
        return ""
    }
    
    ///大小
    public func getVideoSize(_ path :String?) -> UInt64 {
        var fileSize : UInt64 = 0
        if(path == nil || path == "") {
            return fileSize
        }
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path!)
            fileSize = attr[FileAttributeKey.size] as! UInt64
             
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        return fileSize;
    }
    ///封面
    public func saveCoverInLocal(_ path :String?) -> String? {
        if(path == nil || path == "") {
            return ""
        }
        //获取本地视频
        let videoURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: videoURL as URL)
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
        var actualTime:CMTime = CMTimeMake(value: 0,timescale: 0)
        do {
            let imageRef:CGImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
            let img = UIImage(cgImage: imageRef)
            return saveImage(currentImage: img, persent: 10, imageName: "upimg_\(Date().timeIntervalSince1970).jpg");
        }catch{
            print("Error: \(error)")
        }
        return "";
    }
    
    //保存图片至沙盒
    private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String) -> String?{
        if let imageData = currentImage.jpegData(compressionQuality: persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            return fullPath;
        }
        return "";
    }
}
/*路径
 //方法1
 let tmpDir = NSTemporaryDirectory()
  
 //方法2
 let tmpDir2 = NSHomeDirectory() + "/tmp"
 
 */
