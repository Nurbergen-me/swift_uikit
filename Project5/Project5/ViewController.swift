//
//  ViewController.swift
//  Project5
//
//  Created by Nurbergen Yeleshov on 02.12.2020.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }

    func startGame() {
        
        usedWords.removeAll(keepingCapacity: true)
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "usedwords") as? [String] {
            usedWords = savedData
        }
        
        title = defaults.string(forKey: "title")
        
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        
        title = allWords.randomElement()
        
        let defaults = UserDefaults.standard
        defaults.setValue([String](), forKey: "usedwords")
        defaults.setValue(title, forKey: "title")
        
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer ", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    save()
                    
                    return
                } else {
                    showErrorMessage("Word not recognised", "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage("Word used already", "Be more original!")
            }
        } else {
            showErrorMessage("Word not possible", "You can't spell that word from \(title!.lowercased())")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tepmWord = title?.lowercased() else { return false}
        
        if tepmWord == word {
            return false
        }

        for letter in word {
            if let position = tepmWord.firstIndex(of: letter) {
                tepmWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspeledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspeledRange.location == NSNotFound
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func save() {
        let defaults = UserDefaults.standard
        defaults.setValue(usedWords, forKey: "usedwords")
        defaults.setValue(title, forKey: "title")
    }
}

