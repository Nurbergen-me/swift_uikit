//
//  ViewController.swift
//  Project18
//
//  Created by Nurbergen Yeleshov on 15.01.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(1,2,3,4,5, separator: "-", terminator: "!!!")
        //assert(1 == 2, "Math Failure")
        
        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

