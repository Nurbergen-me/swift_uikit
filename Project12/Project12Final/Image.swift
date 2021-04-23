//
//  Image.swift
//  Project12Final
//
//  Created by Nurbergen Yeleshov on 05.01.2021.
//

import UIKit

class Image: NSObject, Codable {
    var image: String
    var name: String
    
    init(image: String, name: String) {
        self.name = name
        self.image = image
    }
}
