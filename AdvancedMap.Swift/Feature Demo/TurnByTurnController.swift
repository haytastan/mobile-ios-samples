//
//  TurnByTurnController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnController: BasePackageDownloadController, NextTurnDelegate {
    
    var client: TurnByTurnClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = TurnByTurnView()
        view = contentView
        
        client = TurnByTurnClient(mapView: contentView.map)
        
        // Offline routing manager and mode
        let source = Routing.ROUTING_TAG + Routing.OFFLINE_ROUTING_SOURCE
        let folder = Utils.createDirectory(name: PackageDownloadBaseView.ROUTING_FOLDER)
        contentView.manager = NTCartoPackageManager(source: source, dataFolder: folder)
        
        client.routing.service = NTPackageManagerValhallaRoutingService(packageManager: contentView.manager)
        
        // Offline map manager and mode
//        let manager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: Utils.createDirectory(name: "countrypackages"))
//        contentView.setOfflineMode(manager: manager!)
        
        contentView.setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        client.onResume()
        client.delegate = self
        
        let text = "Long click on the map to set a destination"
        contentView.banner.showInformation(text: text, autoclose: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        client.onPause()
        client.delegate = nil
    }
    
    override func downloadComplete(sender: PackageListener, id: String) {
        DispatchQueue.main.async {
            self.contentView.banner.showInformation(text: "Download complete!", autoclose: true)
        }
    }
    
    func routingFailed() {
        let text = "Routing failed. Are you sure you've downloaded the correct package?"
        DispatchQueue.main.async {
            self.contentView.banner.showInformation(text: text, autoclose: true)
        }
    }
    
    func instructionFound(current: NTRoutingInstruction, next: NTRoutingInstruction?) {
        (contentView as! TurnByTurnView).turnByTurnBanner.updateInstruction(current: current, next: next)
    }
    
    func locationUpdated(result: NTRoutingResult) {
        (contentView as! TurnByTurnView).turnByTurnBanner.updateRouteInfo(result: result)
    }
}



