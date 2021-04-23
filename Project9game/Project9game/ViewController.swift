//
//  ViewController.swift
//  Project9game
//
//  Created by Nurbergen Yeleshov on 29.12.2020.
//

import UIKit

class ViewController: UITableViewController {
    var words = [String]()
    var hintStrings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            if let fileContent = try? String(contentsOfFile: filePath) {
                var lines = fileContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    
                    let parts = line.components(separatedBy: ": ")
                    
                    var word = parts[0]
                    let hint = parts[1]
                    
                    let hintString = "\(index). \(hint)"
                    hintStrings.append(hintString)
                    
                    word = word.replacingOccurrences(of: "|", with: "")
                    words.append(word)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = hintStrings[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.hintString = hintStrings[indexPath.row]
        vc.answerString = words[indexPath.row]
        navigationController?.showDetailViewController(vc, sender: ViewController())
    }
}

