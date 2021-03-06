//
//  ViewController.swift
//  Project2
//
//  Created by Nurbergen Yeleshov on 08.11.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var totalScore: UILabel!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score = score>0 ? score-1 : 0
        }
        
        questionNum += 1
        save()
        totalScore.text = "\(score)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: totalScore)
        
        if questionNum % 10 == 0 {
            let ac = UIAlertController(title: title, message: "It's your \(questionNum)th question. Your total score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
            
        } else if title.hasPrefix("Wrong") {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        } else {
            askQuestion()
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = .identity
        })
    }
    
    func save() {
        
        let defaults = UserDefaults.standard
        let finalScore = defaults.integer(forKey: "finalScore")
        
        if score > finalScore {
            defaults.setValue(score, forKey: "finalScore")
            
        }
        
        if score == finalScore+1 {
            let ac = UIAlertController(title: "Congratulations", message: "You beat the previous record!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
            
        }
    }
}

