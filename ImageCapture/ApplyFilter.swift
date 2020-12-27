//
//  ApplyFilter.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/26/20.
//

import Foundation

class ApplyFilter {
    var filter: String
    var intensity: [String]?
    var color: [String]?
    
    init(filter: String, intensity: [String]?=nil, color: [String]?=nil) {
        self.filter = filter
        self.intensity = intensity
        self.color = color
    }
}
