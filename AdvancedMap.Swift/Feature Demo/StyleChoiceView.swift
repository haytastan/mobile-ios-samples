//
//  StyleChoiceView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StyleChoiceView : MapBaseView {

    var languageButton: PopupButton!
    var baseMapButton: PopupButton!
    
    var languageContent: LanguagePopupContent!
    var baseMapContent: StylePopupContent!
    
    var currentLanguage: String = ""
    var currentSource: String = "carto.streets"
    var currentLayer: NTTileLayer!

    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        initialize()
        
        currentLayer = addBaseLayer()
        
        languageButton = PopupButton(imageUrl: "icon_language.png")
        baseMapButton = PopupButton(imageUrl: "icon_basemap.png")
        
        addButton(button: languageButton)
        addButton(button: baseMapButton)
        
        infoContent.setText(headerText: Texts.basemapInfoHeader, contentText: Texts.basemapInfoContainer)
        
        languageContent = LanguagePopupContent()
        baseMapContent = StylePopupContent()
        baseMapContent.highlightDefault()
    }

    override func addRecognizers() {
        
        super.addRecognizers()
        
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(self.languageButtonTapped(_:)))
        languageButton.addGestureRecognizer(recognizer)
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.mapButtonTapped(_:)))
        baseMapButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        
        super.removeRecognizers()
        
        languageButton.gestureRecognizers?.forEach(languageButton.removeGestureRecognizer)
        baseMapButton.gestureRecognizers?.forEach(baseMapButton.removeGestureRecognizer)
    }
    
    func languageButtonTapped(_ sender: UITapGestureRecognizer) {
        
        if (languageButton.isEnabled) {
            popup.setContent(content: languageContent)
            popup.popup.header.setText(text: "SELECT A LANGUAGE")
            popup.show()
        }
    }
    
    func mapButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: baseMapContent)
        popup.popup.header.setText(text: "SELECT A BASEMAP")
        popup.show()
    }
    
    func updateMapLanguage(language: String) {
        
        if (currentLayer == nil) {
            return
        }
        
        currentLanguage = language
        
        let decoder = (currentLayer as? NTVectorTileLayer)?.getTileDecoder() as? NTMBVectorTileDecoder
        decoder?.setStyleParameter("lang", value: currentLanguage)
    }

    func updateBaseLayer(selection: String, source: String) {
        
        if (source == StylePopupContent.CartoVectorSource) {
            
            if (selection == StylePopupContent.Positron) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_POSITRON)
            } else if (selection == StylePopupContent.DarkMatter) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_DARKMATTER)
            } else if (selection == StylePopupContent.Voyager) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_VOYAGER)
            }
            
        } else if (source == StylePopupContent.MapzenSource) {
            
            let asset = NTAssetUtils.loadAsset("styles_mapzen.zip")

            let package = NTZippedAssetPackage(zip: asset)
            
            var name = ""
            
            if (selection == StylePopupContent.Bright) {
                name = "style"
            } else if (selection == StylePopupContent.Positron) {
                name = "positron"
            } else if (selection == StylePopupContent.DarkMatter) {
                name = "positron_dark"
            }
            
            let styleSet = NTCompiledStyleSet(assetPackage: package, styleName: name)
            
            let datasource = NTCartoOnlineTileDataSource(source: source)
            let decoder = NTMBVectorTileDecoder(compiledStyleSet: styleSet)
            
            currentLayer = NTVectorTileLayer(dataSource: datasource, decoder: decoder)
            
        } else if (source == StylePopupContent.CartoRasterSource) {
            
            // We know that the value of raster will be Positron or Darkmatter,
            // as CARTO and Mapzen use vector tiles
            var url = ""
            
            if (selection == StylePopupContent.Positron) {
                url = StylePopupContent.PositronUrl
            } else {
                url = StylePopupContent.DarkMatterUrl
            }
            
            let datasource = NTHTTPTileDataSource(minZoom: 1, maxZoom: 19, baseURL: url)
            currentLayer = NTRasterTileLayer(dataSource: datasource)
        }
        
        if (source == StylePopupContent.CartoRasterSource) {
            languageButton.disable()
        } else {
            languageButton.enable()
        }
        
        map.getLayers().clear()
        map.getLayers().add(currentLayer)
        
        updateMapLanguage(language: currentLanguage)
    }
}





















