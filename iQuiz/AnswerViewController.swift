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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🟢 AnswerViewController loaded")
        
        // Check if all required data is passed
        validateData()
        
        setupUI()
        setupTableView()
        setupSwipeGestures()
    }
    
    // MARK: - Data Validation
    private func validateData() {
        // Check if question exists
        if question == nil {
            print("❌ Error: question is nil")
        }
        
        // Check if answer index exists
        if selectedAnswerIndex == nil {
            print("❌ Error: selectedAnswerIndex is nil")
        }
        
        // Check if quiz exists
        if quiz == nil {
            print("❌ Error: quiz is nil")
        }
        
        // Print all received data for debugging
        print("📦 Received data:")
        print("  - Question: \(question?.text ?? "nil")")
        print("  - Selected index: \(selectedAnswerIndex ?? -1)")
        print("  - Is correct: \(isCorrect)")
        print("  - Quiz title: \(quiz?.title ?? "nil")")
        print("  - Current index: \(currentQuestionIndex)")
        print("  - Score: \(score)")
        print("  - Total questions: \(totalQuestions)")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Safely unwrap optionals
        guard let question = question else {
            print("❌ setupUI: Cannot setup UI because question is nil")
            return
        }
        
        guard let selectedIndex = selectedAnswerIndex else {
            print("❌ setupUI: Cannot setup UI because selectedAnswerIndex is nil")
            return
        }
        
        // Check IBOutlets
        guard questionLabel != nil, resultLabel != nil, nextButton != nil, tableView != nil else {
            print("❌ setupUI: Some IBOutlets are nil - check Storyboard connections")
            return
        }
        
        print("✅ setupUI: All IBOutlets are connected")
        
        // Set navigation title
        title = quiz?.title ?? "Answer"
        
        // Configure next button
        nextButton.layer.cornerRadius = 8
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Display question text
        questionLabel.text = question.text
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        questionLabel.textAlignment = .center
        
        // Display result (correct/wrong)
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
        
        print("✅ UI Setup completed")
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
        
        print("✅ Swipe gestures setup")
    }
    
    // MARK: - Swipe Gesture Handlers
    @objc func handleSwipeRight() {
        print("👉 Swipe right detected - Next")
        nextTapped(nextButton)
    }
    
    @objc func handleSwipeLeft() {
        print("👈 Swipe left detected - Abandon quiz")
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
            print("🚪 Abandoning quiz and returning to main list")
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func nextTapped(_ sender: UIButton) {
        print("➡️ Next button tapped")
        
        guard let quiz = quiz else {
            print("❌ quiz is nil")
            return
        }
        
        let nextQuestionIndex = currentQuestionIndex + 1
        
        if nextQuestionIndex < quiz.questions.count {
            // More questions left, go back to QuestionViewController with next question
            print("➡️ Moving to next question (\(nextQuestionIndex + 1)/\(quiz.questions.count))")
            
            // get navigation stack QuestionViewController
            if let questionVC = navigationController?.viewControllers.first(where: { $0 is QuestionViewController }) as? QuestionViewController {
                
                //update QuestionViewController
                questionVC.currentQuestionIndex = nextQuestionIndex
                questionVC.score = score
                questionVC.quiz = quiz
                
                // return QuestionViewController
                navigationController?.popToViewController(questionVC, animated: true)
            } else {
                print("❌ Could not find QuestionViewController in navigation stack")
                navigationController?.popToRootViewController(animated: true)
            }
        } else {
            // Last question, go to FinishedViewController
            print("🏁 Quiz completed! Going to finished scene")
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("🔄 prepareForSegue: \(segue.identifier ?? "nil")")
        
        if segue.identifier == "ShowFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            // Pass score and total questions to finished scene
            finishedVC.score = score
            finishedVC.totalQuestions = totalQuestions
            
            print("📤 Passing data to FinishedViewController:")
            print("  - Score: \(score)")
            print("  - Total questions: \(totalQuestions)")
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
        
        // Safely unwrap question and selected index
        guard let question = question,
              let selectedIndex = selectedAnswerIndex else {
            cell.textLabel?.text = "Error loading answers"
            return cell
        }
        
        let answer = question.answers[indexPath.row]
        cell.textLabel?.text = answer
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // Mark correct answer in green
        if indexPath.row == question.correctAnswerIndex {
            cell.textLabel?.textColor = .systemGreen
            cell.textLabel?.text = "✅ \(answer) (Correct answer)"
        } else {
            cell.textLabel?.textColor = .black
        }
        
        // Mark user's wrong answer in red
        if indexPath.row == selectedIndex && !isCorrect {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = "❌ \(answer) (Your answer - Wrong)"
        }
        
        // If user was correct, their answer is already marked as correct above
        // No need to duplicate marking
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AnswerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
