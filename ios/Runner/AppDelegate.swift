import Flutter
import UIKit
import GoogleMaps
import Firebase
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() 
    // <- ✅ ต้องมีบรรทัดนี้
    GMSServices.provideAPIKey("AIzaSyD-pkE26l2sWEU_CrbDz6b2myMe5Ab7jJo")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
