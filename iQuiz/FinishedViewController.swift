//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/19/2026.
//

import UIKit

class FinishedViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var score: Int = 0
    var totalQuestions: Int = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Quiz Complete"
        
        // Calculate percentage
        let percentage = Double(score) / Double(totalQuestions) * 100
        
        // Set descriptive text based on performance
        if percentage == 100 {
            resultLabel.text = "🏆 Perfect!"
            resultLabel.textColor = .systemYellow
        } else if percentage >= 80 {
            resultLabel.text = "🌟 Almost!"
            resultLabel.textColor = .systemGreen
        } else if percentage >= 60 {
            resultLabel.text = "👍 Good job!"
            resultLabel.textColor = .systemBlue
        } else if percentage >= 40 {
            resultLabel.text = "📚 Keep practicing!"
            resultLabel.textColor = .systemOrange
        } else {
            resultLabel.text = "💪 Try again!"
            resultLabel.textColor = .systemRed
        }
        
        // Display score
        scoreLabel.text = "You got \(score) out of \(totalQuestions) correct"
        
        // Configure next button
        nextButton.setTitle("Done", for: .normal)
        nextButton.layer.cornerRadius = 8
    }
    
    private func setupSwipeGestures() {
        // Swipe Left = Return to list
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Swipe Gesture Handlers
    @objc func handleSwipeLeft() {
        print("Swipe left detected - Return to list")
        nextTapped()
    }
    
    // MARK: - Actions
    @IBAction func nextTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
