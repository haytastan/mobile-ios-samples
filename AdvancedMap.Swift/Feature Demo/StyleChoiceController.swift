//
//  StyleChoiceController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StyleChoiceController : BaseController, UITableViewDelegate, StyleUpdateDelegate, MapOptionsUpdateDelegate {
    
    var contentView: StyleChoiceView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView = StyleChoiceView()
    
        view = contentView
        
        contentView.languageContent.addLanguages(languages: Languages.list)
        contentView.mapOptionsContent.addOptions(mapOptions: MapOptions.list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        contentView.languageContent.table.delegate = self
        
        contentView.baseMapContent.cartoVector.delegate = self
        contentView.baseMapContent.cartoRaster.delegate = self
        
        contentView.mapOptionsContent.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.languageContent.table.delegate = nil
        
        contentView.baseMapContent.cartoVector.delegate = nil
        contentView.baseMapContent.cartoRaster.delegate = nil
        
        contentView.mapOptionsContent.delegate = nil
    }
    
    var previous: StylePopupContentSectionItem!
    
    func styleClicked(selection: StylePopupContentSectionItem, source: String) {
        contentView.popup.hide()
        contentView.updateBaseLayer(selection: selection.label.text!, source: source)
        
        if (previous != nil) {
            previous.normalize()
        } else {
            contentView.baseMapContent.normalizeDefaultHighlight()
        }
        
        selection.highlight()
        previous = selection
    }
    
    func optionClicked(option: String, turnOn: Bool) {
        contentView.popup.hide()
        contentView.updateMapOption(option: option, value: turnOn)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = contentView.languageContent.languages[indexPath.row]
        contentView.popup.hide()
        contentView.updateMapLanguage(language: language.value)
    }
    
}
