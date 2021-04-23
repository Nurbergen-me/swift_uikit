//
//  ViewController.swift
//  Project12Final
//
//  Created by Nurbergen Yeleshov on 05.01.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var images = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        
        let defaults = UserDefaults.standard
        if let savedImages = defaults.object(forKey: "images") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                images = try jsonDecoder.decode([Image].self, from: savedImages)
            } catch {
                print("Failed to load Images")
            }
        }
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let newImage = Image(image: imageName, name: "Unknown")
        images.append(newImage)
        save()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = images[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let imageViewController = storyboard?.instantiateViewController(identifier: "imageViewController") as? ImageView {
            imageViewController.image = images[indexPath.row].image
            
            navigationController?.pushViewController(imageViewController, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "images")
        } else {
            print("Failed to save images")
        }
    }


}

