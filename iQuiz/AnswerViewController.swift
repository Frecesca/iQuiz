//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/19/2026.
//

import UIKit

class AnswerViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var question: Question?
    var selectedAnswerIndex: Int?
    var isCorrect: Bool = false
    var quiz: Quiz?
    var currentQuestionIndex: Int = 0
    var score: Int = 0
    var totalQuestions: Int = 0
    
    // For swipe gestures
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        guard let question = question,
              let selectedIndex = selectedAnswerIndex else { return }
        
        questionLabel.text = question.text
        questionLabel.numberOfLines = 0
        
        // Show result
        if isCorrect {
            resultLabel.text = "✅ Correct!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "❌ Wrong!"
            resultLabel.textColor = .systemRed
        }
        
        // Show correct answer
        let correctAnswer = question.answers[question.correctAnswerIndex]
        correctAnswerLabel.text = "Correct answer: \(correctAnswer)"
        
        // Show user's answer
        let userAnswer = question.answers[selectedIndex]
        yourAnswerLabel.text = "Your answer: \(userAnswer)"
        
        // Configure next button
        nextButton.layer.cornerRadius = 8
    }
    
    private func setupSwipeGestures() {
        // Swipe Right = Next
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Swipe Left = Abandon quiz
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Swipe Gesture Handlers
    @objc func handleSwipeRight() {
        print("Swipe right detected - Next")
        nextTapped()
    }
    
    @objc func handleSwipeLeft() {
        print("Swipe left detected - Abandon quiz")
        abandonQuiz()
    }
    
    private func abandonQuiz() {
        let alert = UIAlertController(
            title: "Abandon Quiz?",
            message: "Are you sure you want to quit? Your progress will be lost.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Quit", style: .destructive) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func nextTapped() {
        guard let quiz = quiz else { return }
        
        let nextQuestionIndex = currentQuestionIndex + 1
        
        if nextQuestionIndex < quiz.questions.count {
            // Go to next question
            if let questionVC = navigationController?.viewControllers.first(where: { $0 is QuestionViewController }) as? QuestionViewController {
                questionVC.currentQuestionIndex = nextQuestionIndex
                questionVC.score = score
                questionVC.quiz = quiz
                navigationController?.popToViewController(questionVC, animated: true)
            }
        } else {
            // Go to finished scene
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.score = score
            finishedVC.totalQuestions = totalQuestions
        }
    }
}
