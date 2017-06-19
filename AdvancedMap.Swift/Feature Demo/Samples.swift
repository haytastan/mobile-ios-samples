//
//  Samples.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Samples {
    
    static var list = [Sample]()
    
    static func initialize() {
        
        let folder = ""//"Gallery/"
        
        var sample = Sample()
        sample.title = "STYLES"
        sample.description = "Various samples of different carto base maps"
        sample.imageResource = folder + "icon_sample_styles.png"
        sample.controller = StyleChoiceController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "BBOX ROUTING"
        sample.description = "Bounding box download with offline routing"
        sample.imageResource = folder + "icon_sample_styles.png"
        sample.controller = StyleChoiceController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "REGIONAL ROUTING"
        sample.description = "Region download with offline routing"
        sample.imageResource = folder + "icon_sample_styles.png"
        sample.controller = StyleChoiceController()
        
        list.append(sample)
    }
}
