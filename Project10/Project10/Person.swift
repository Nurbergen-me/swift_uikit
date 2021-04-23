//
//  Person.swift
//  Project10
//
//  Created by Nurbergen Yeleshov on 30.12.2020.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
