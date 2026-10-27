import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  let w=UIWindow(frame:UIScreen.main.bounds); w.backgroundColor=UIColor(red:0.035,green:0.055,blue:0.11,alpha:1); w.rootViewController=ViewController(); w.makeKeyAndVisible(); window=w; return true
 }
}