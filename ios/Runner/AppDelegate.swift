import Flutter
import UIKit
import AppTrackingTransparency
import AdSupport

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // ATT запрос на iOS 14+
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { _ in
        // Статус будет учтён SDK (AppsFlyer, AdMob и др.)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
