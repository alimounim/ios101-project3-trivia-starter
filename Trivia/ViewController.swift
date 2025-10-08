//
//  ViewController.swift
//  Trivia
//
//  Created by Ali Mounim Rajabi on 10/7/25.
//

import UIKit

// Data Model
struct Question {
    let category: String
    let prompt: String
    let choices: [String]   // must be 4
    let answerIndex: Int    // 0...3
}

class ViewController: UIViewController {
    
    // Connecting Storyboard UI elements to code
    // MARK: - Outlets (Top)
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    // MARK: - Outlet (Middle)
    @IBOutlet weak var questionLabel: UILabel!

    // MARK: - Outlets (Bottom)
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!

    // Quiz Content
    private let questions: [Question] = [
        Question(category: "Entertainment: Video Games",
                 prompt: "What was the first weapon pack for 'PAYDAY'?",
                 choices: ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"],
                 answerIndex: 0),
        Question(category: "Entertainment: Music",
                 prompt: "What is the last song on the first Panic! At the Disco album?",
                 choices: ["I Write Sins Not Tragedies", "Camisado", "Nails for Breakfast, Tacks for Snacks", "Build God, Then We'll Talk"],
                 answerIndex: 3),
        Question(category: "Entertainment: Video Games",
                 prompt: "Which company makes the Nintendo Switch?",
                 choices: ["Sony", "Nintendo", "Microsoft", "Sega"],
                 answerIndex: 1)
    ]

    // MARK: - State
    
    // Which question I am working right now
    private var currentIndex = 0
    // How many correct answers
    private var score = 0
    // Determines if I have worked with a question to avoid repetition
    private var hasAnswered = false

    // Convenience
    private var answerButtons: [UIButton] { [answerA, answerB, answerC, answerD] }

    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trivia"
        view.backgroundColor = .systemTeal
        
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.textAlignment = .center
        
        // Configure buttons (gray by default)
        for (i, button) in answerButtons.enumerated() {
            button.tag = i
            button.configuration = nil    // makes backgroundColor changes work
            button.layer.cornerRadius = 12
            button.layer.masksToBounds = true
            button.backgroundColor = .systemGray3  // default gray
            button.setTitleColor(.white, for: .normal)
        }
        
        showCurrentQuestion()
    }


    // MARK: - UI Updates
    private func showCurrentQuestion() {
        hasAnswered = false

        let q = questions[currentIndex]
        progressLabel.text = "Question: \(currentIndex + 1)/\(questions.count)"
        categoryLabel.text = q.category
        questionLabel.text = q.prompt

        // Set button titles + reset state
        for (i, button) in answerButtons.enumerated() {
            button.setTitle(q.choices[i], for: .normal)
            button.isEnabled = true
            button.backgroundColor = .systemGray3  // reset to gray
        }
    }

    private func advanceOrFinish() {
        if currentIndex == questions.count - 1 {
            let alert = UIAlertController(
                title: "Game over!",
                message: "Final score: \(score)/\(questions.count)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.currentIndex = 0
                self.score = 0
                self.showCurrentQuestion()
            })
            present(alert, animated: true)
        } else {
            currentIndex += 1
            showCurrentQuestion()
        }
    }

    // MARK: - Actions
    @IBAction func answerTapped(_ sender: UIButton) {
        guard !hasAnswered else { return }
        hasAnswered = true

        let correctIndex = questions[currentIndex].answerIndex

        // Color feedback + lock buttons
        for (i, b) in answerButtons.enumerated() {
            b.isEnabled = false
            if i == correctIndex {
                b.backgroundColor = .systemGreen
            } else if b == sender {
                b.backgroundColor = .systemRed
            } else {
                b.backgroundColor = .systemTeal
            }
        }

        if sender.tag == correctIndex { score += 1 }

        // Short pause, then advance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.advanceOrFinish()
        }
    }
}

