//
//  ImageView.swift
//  Project12Final
//
//  Created by Nurbergen Yeleshov on 05.01.2021.
//

import UIKit

class ImageView: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var image: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image"
        navigationItem.largeTitleDisplayMode = .never
        
        let path = getDocumentsDirectory().appendingPathComponent(image!)
        imageView.image = UIImage(contentsOfFile: path.path)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
