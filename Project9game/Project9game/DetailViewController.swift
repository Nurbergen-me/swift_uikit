//
//  DetailViewController.swift
//  Project9game
//
//  Created by Nurbergen Yeleshov on 29.12.2020.
//

import UIKit

class DetailViewController: UIViewController {
    var detailHint: UILabel!
    var scoreLabel: UILabel!
    var questionWord: UILabel!
    var currentAnswer: UITextField!
    var lettersButton = [UIButton]()

    var hintString: String?
    var answerString: String?
    var choosenLetters = [String]()
    
    var score = 0
    
    var letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","'"]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        detailHint = UILabel()
        detailHint.translatesAutoresizingMaskIntoConstraints = false
        detailHint.textAlignment = .center
        detailHint.font = UIFont.systemFont(ofSize: 20)
        detailHint.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(detailHint)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        questionWord = UILabel()
        questionWord.translatesAutoresizingMaskIntoConstraints = false
        questionWord.textAlignment = .center
        questionWord.text = "\(choosenLetters.joined())"
        questionWord.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(questionWord)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 18)
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            detailHint.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 80),
            detailHint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            questionWord.topAnchor.constraint(equalTo: detailHint.bottomAnchor, constant: 20),
            questionWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: questionWord.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 100),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 315),
            buttonsView.heightAnchor.constraint(equalToConstant: 200),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            
        ])
        
        
        let width = 35
        let height = 60
        var count = 0
        
        for column in 0..<3 {
            for row in 0..<9 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                letterButton.setTitle("\(letters[count])", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: row * width, y: column * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                lettersButton.append(letterButton)
                count += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailHint.text = hintString
        for _ in answerString! {
            choosenLetters.append("*")
        }
        
        questionWord.text = choosenLetters.joined()
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letterText = sender.titleLabel?.text else { return }
        
        for (index, letter) in answerString!.enumerated() {
            if letter.lowercased() == letterText {
                choosenLetters[index] = letterText
                score += 1
            } else {
                if score >= 1 { score -= 1}
            }
        }
        
        scoreLabel.text = "Score: \(score)"
        questionWord.text = choosenLetters.joined()
        
        if !choosenLetters.contains("*") {
            let ac = UIAlertController(title: "Well done!", message: "You found the word - \(questionWord.text!.uppercased())", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
        }
    }
    

}
