//
//  ViewController.swift
//  Project1
//
//  Created by Nurbergen Yeleshov on 05.11.2020.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }
        }
        pictures.sort()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCell else {
            fatalError()
        }
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.count.text = "0" 
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.totalNumber = pictures.count
            vc.selectedId = indexPath.item
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

