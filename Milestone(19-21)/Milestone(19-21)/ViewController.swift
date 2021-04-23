//
//  ViewController.swift
//  Milestone(19-21)
//
//  Created by Nurbergen Yeleshov on 23.01.2021.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Заметки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNode))
        
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            }
            catch {
                print("Failed to load data")
            }
        }
        
    }
    
    @objc func addNode() {
        notes.insert(Note(title: "Untitled", body: ""), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.noteText = notes[indexPath.row].title
        vc.givText(text: notes[indexPath.row].body)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(savedData, forKey: "notes")
        } else {
            print("Failed to save")
        }
    }
}

