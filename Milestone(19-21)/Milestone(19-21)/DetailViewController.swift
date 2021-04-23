//
//  DetailViewController.swift
//  Milestone(19-21)
//
//  Created by Nurbergen Yeleshov on 23.01.2021.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    var noteText: String?

    var textVieww: UITextView = {
        let textView = UITextView()
        textView.text = "12123123"
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.font = UIFont.systemFont(ofSize: 24)
        return textView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        title = noteText ?? "Untitled"
        view.backgroundColor = .white
        view.addSubview(textVieww)
        
        NSLayoutConstraint.activate([
            textVieww.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textVieww.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textVieww.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textVieww.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
    }
    
    func givText(text: String) {
        textVieww.text = text   
    }
    
    @objc func saveNote() {
        guard let text = textVieww.text else { return }
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(text, forKey: "note")
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textVieww.contentInset = .zero
        } else {
            textVieww.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textVieww.scrollIndicatorInsets = textVieww.contentInset
        let selectedRange = textVieww.selectedRange
        textVieww.scrollRangeToVisible(selectedRange)
    }
    

}
