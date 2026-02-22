//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/22/2026.
//

import UIKit

class AnswerViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
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
        setupTableView()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        guard let question = question,
              let selectedIndex = selectedAnswerIndex else { return }
        
        // Set navigation title
        title = quiz?.title ?? "Answer"
        
        // Configure button style
        nextButton.layer.cornerRadius = 8
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Display question
        questionLabel.text = question.text
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        questionLabel.textAlignment = .center
        
        // Display result
        if isCorrect {
            resultLabel.text = "✅ CORRECT!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "❌ WRONG!"
            resultLabel.textColor = .systemRed
        }
        resultLabel.font = UIFont.boldSystemFont(ofSize: 24)
        resultLabel.textAlignment = .center
        
        // Change button text based on whether this is the last question
        if let quiz = quiz, currentQuestionIndex == quiz.questions.count - 1 {
            nextButton.setTitle("SEE RESULTS", for: .normal)
        } else {
            nextButton.setTitle("NEXT QUESTION", for: .normal)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerCell")
        tableView.allowsSelection = false  // Disable selection on answer page
        tableView.tableFooterView = UIView()  // Remove extra separators
        tableView.rowHeight = 60
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
            // More questions left, go back to QuestionViewController with next question
            if let questionVC = navigationController?.viewControllers.first(where: { $0 is QuestionViewController }) as? QuestionViewController {
                questionVC.currentQuestionIndex = nextQuestionIndex
                questionVC.score = score
                questionVC.quiz = quiz
                navigationController?.popToViewController(questionVC, animated: true)
            }
        } else {
            // Last question, go to FinishedViewController
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            // Pass score and total questions to finished scene
            finishedVC.score = score
            finishedVC.totalQuestions = totalQuestions
        }
    }
}

// MARK: - UITableViewDataSource
extension AnswerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        guard let question = question,
              let selectedIndex = selectedAnswerIndex else { return cell }
        
        let answer = question.answers[indexPath.row]
        cell.textLabel?.text = answer
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // Mark correct answer
        if indexPath.row == question.correctAnswerIndex {
            cell.textLabel?.textColor = .systemGreen
            cell.textLabel?.text = "✅ \(answer) (Correct answer)"
        } else {
            cell.textLabel?.textColor = .black
        }
        
        // Mark user's answer if it was wrong
        if indexPath.row == selectedIndex && !isCorrect {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = "❌ \(answer) (Your answer - Wrong)"
        }
        
        // If user was correct, their answer is already marked as correct
        if indexPath.row == selectedIndex && isCorrect {
            cell.textLabel?.textColor = .systemGreen
            cell.textLabel?.text = "✅ \(answer) (Your answer - Correct)"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AnswerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
