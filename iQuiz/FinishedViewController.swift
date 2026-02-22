//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/22/2026.
//

import UIKit

class FinishedViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!  
    
    // MARK: - Properties
    var score: Int = 0
    var totalQuestions: Int = 0
    
    // For swipe gesture
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🟢 FinishedViewController loaded")
        print("📊 Score: \(score)/\(totalQuestions)")
        
        setupUI()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Quiz Complete"
        
        // Configure done button
        doneButton.layer.cornerRadius = 8
        doneButton.backgroundColor = .systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitle("DONE", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Calculate percentage
        let percentage = totalQuestions > 0 ? Double(score) / Double(totalQuestions) * 100 : 0
        
        // Set descriptive text based on performance
        if percentage == 100 {
            resultLabel.text = "🏆 PERFECT!"
            resultLabel.textColor = .systemYellow
        } else if percentage >= 80 {
            resultLabel.text = "🌟 ALMOST!"
            resultLabel.textColor = .systemGreen
        } else if percentage >= 60 {
            resultLabel.text = "👍 GOOD JOB!"
            resultLabel.textColor = .systemBlue
        } else if percentage >= 40 {
            resultLabel.text = "📚 KEEP PRACTICING!"
            resultLabel.textColor = .systemOrange
        } else {
            resultLabel.text = "💪 TRY AGAIN!"
            resultLabel.textColor = .systemRed
        }
        
        resultLabel.font = UIFont.boldSystemFont(ofSize: 36)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 1
        
        // Display score
        scoreLabel.text = "You got \(score) out of \(totalQuestions) correct"
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .darkGray
        scoreLabel.numberOfLines = 2
    }
    
    private func setupSwipeGestures() {
        // Swipe Left = Return to quiz list
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Swipe Gesture Handlers
    @objc func handleSwipeLeft() {
        print("👈 Swipe left detected - Return to quiz list")
        returnToQuizList()
    }
    
    private func returnToQuizList() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Actions
    @IBAction func doneTapped(_ sender: UIButton) {
        print("✅ Done button tapped")
        returnToQuizList()
    }
}
