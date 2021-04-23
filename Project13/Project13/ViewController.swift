//
//  ViewController.swift
//  Project13
//
//  Created by Nurbergen Yeleshov on 06.01.2021.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var filterName: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intencity: UISlider!
    @IBOutlet var intencity2: UISlider!
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    var currentFilter2: CIFilter!
    var filter: CIFilter!
    
    var intencityValue: Float?
    var restID = "first" {
        didSet {
            if restID == "first" {
                intencityValue = intencity.value
                filter = currentFilter
                
            } else if restID == "second" {
                intencityValue = intencity2.value
                filter = currentFilter2
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        currentFilter2 = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        if restID == "second" {
            filter = currentFilter2
        } else {
            filter = currentFilter
        }
        guard let image = filter.outputImage else { return }
        guard let intencity = intencityValue else { return }
        let inputKeys = filter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { filter.setValue(intencity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { filter.setValue(intencity * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { filter.setValue(intencity * 10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) { filter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)}
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
        
    }
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        filterName.setTitle(actionTitle, for: .normal)
        
        guard currentImage != nil else { return }
        
        filter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImage)
        filter!.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "There is no image to save!", message: "Please select image from your gallery", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:context:)), nil)
    }
    @IBAction func intencityChanged(_ sender: UISlider) {
        guard let id = sender.restorationIdentifier else { return }
        restID = id
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, context: UnsafeRawPointer) {
        if let error  = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}

