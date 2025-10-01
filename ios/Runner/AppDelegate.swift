import UIKit
import Flutter
import GoogleMaps   // ← 추가

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Info.plist에 있는 GMSApiKey를 읽어서 주입
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
       apiKey.isEmpty == false {
      GMSServices.provideAPIKey(apiKey)
    } else {
      // 개발 중 키가 비어있으면 크래시 방지용 로그 (필수는 아님)
      NSLog("GMSApiKey is missing in Info.plist")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}