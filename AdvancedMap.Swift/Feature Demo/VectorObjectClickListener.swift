//
//  VectorObjectClickListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CartoMobileSDK

class VectorObjectClickListener : NTVectorElementEventListener {
    
    static let CLICK_TITLE = "click_title"
    static let CLICK_DESCRIPTION = "click_description"
    
    var source: NTLocalVectorDataSource!
    
    var previous: NTBalloonPopup!
    
    override func onVectorElementClicked(_ clickInfo: NTVectorElementClickInfo!) -> Bool {
        
        if (previous != nil) {
            source.remove(previous)
        }
        
        let element = clickInfo.getVectorElement()
        
        let animationBuilder = NTAnimationStyleBuilder()
        animationBuilder?.setRelativeSpeed(2.0)
        animationBuilder?.setSizeAnimationType(NTAnimationType.ANIMATION_TYPE_SPRING)
        
        let builder = NTBalloonPopupStyleBuilder()
        builder?.setLeftMargins(NTBalloonPopupMargins(left: 0, top: 0, right: 0, bottom: 0))
        builder?.setRightMargins(NTBalloonPopupMargins(left: 6, top: 3, right: 6, bottom: 3))
        builder?.setTitleColor(Colors.navy.toNTColor())
        builder?.setTitleFontSize(12)
        builder?.setDescriptionFontSize(10)
        builder?.setCornerRadius(5)
        builder?.setDescriptionColor(UIColor.gray.toNTColor())
        builder?.setAnimationStyle(animationBuilder?.buildStyle())
        
        let style = builder?.buildStyle()
        
        if !(element!.containsMetaDataKey(VectorObjectClickListener.CLICK_TITLE)) {
            return true
        }
        
        let title = element?.getMetaDataElement(VectorObjectClickListener.CLICK_TITLE).getString()
        let description = element?.getMetaDataElement(VectorObjectClickListener.CLICK_DESCRIPTION).getString()
        
        
        var popup: NTBalloonPopup?
        
        if let billboard = element as? NTBillboard {
            popup = NTBalloonPopup(baseBillboard: billboard as NTBillboard, style: style, title: title, desc: description)
        } else {
            popup = NTBalloonPopup(pos: clickInfo.getClickPos(), style: style, title: title, desc: description)
        }
        
        source.add(popup)
        previous = popup
        
        return true
    }
    
    func reset() {
        if (previous != nil) {
            source.remove(previous)
            previous = nil
        }
    }
}
