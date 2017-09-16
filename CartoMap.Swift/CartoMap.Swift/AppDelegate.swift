//
//  AppDelegate.swift
//  HelloMap.Swift
//
//  Created by Aare Undo on 22/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var License = "XTUM0Q0ZRQ253QllUc2pweno2dmM1RGtxMnFybVZyWldRd0lWQUpKN1dOOXU5bDRiWXJFKzhvZHhoUlE2YXlBegoKYXBwVG9rZW49YjUwNzg2YzUtZjg3OS00NTI0LTg1ZGEtMWQyNzdlZjIyMTY1CmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmNhcnRvLm1hcC5zd2lmdApvbmxpbmVMaWNlbnNlPTEKcHJvZHVjdHM9c2RrLWlvcy00LioKd2F0ZXJtYXJrPWN1c3RvbQo=";
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NTMapView.registerLicense(License);
        
        window?.rootViewController = UINavigationController(rootViewController: LauncherListController());
        
        window?.makeKeyAndVisible();
        
        return true
    }

}

