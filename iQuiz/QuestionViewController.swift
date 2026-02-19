//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/19/2026.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    var quiz: Quiz?
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int?
    var score = 0
    var questions: [Question] = []
    
    // For swipe gestures
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSwipeGestures()
        loadCurrentQuestion()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = quiz?.title ?? "Quiz"
        submitButton.layer.cornerRadius = 8
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerCell")
    }
    
    private func setupSwipeGestures() {
        // Swipe Right = Submit
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Swipe Left = Abandon quiz
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Show hint for swipe gestures
        showSwipeHint()
    }
    
    private func showSwipeHint() {
        let hintLabel = UILabel()
        hintLabel.text = "⬅️ Swipe left to quit | Swipe right to submit ➡️"
        hintLabel.font = UIFont.systemFont(ofSize: 12)
        hintLabel.textColor = .gray
        hintLabel.textAlignment = .center
        hintLabel.backgroundColor = UIColor.systemGray6
        hintLabel.layer.cornerRadius = 10
        hintLabel.layer.masksToBounds = true
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hintLabel)
        
        NSLayoutConstraint.activate([
            hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hintLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Hide after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5) {
                hintLabel.alpha = 0
            }
        }
    }
    
    private func loadCurrentQuestion() {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return }
        
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        tableView.reloadData()
    }
    
    // MARK: - Swipe Gesture Handlers
    @objc func handleSwipeRight() {
        print("Swipe right detected - Submit")
        submitTapped()
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
    @IBAction func submitTapped() {
        guard let quiz = quiz,
              let selectedIndex = selectedAnswerIndex,
              currentQuestionIndex < quiz.questions.count else { return }
        
        let question = quiz.questions[currentQuestionIndex]
        let isCorrect = selectedIndex == question.correctAnswerIndex
        
        if isCorrect {
            score += 1
        }
        
        // Navigate to answer view controller
        performSegue(withIdentifier: "ShowAnswer", sender: (question, selectedIndex, isCorrect))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let answerVC = segue.destination as? AnswerViewController,
           let (question, selectedIndex, isCorrect) = sender as? (Question, Int, Bool) {
            
            answerVC.question = question
            answerVC.selectedAnswerIndex = selectedIndex
            answerVC.isCorrect = isCorrect
            answerVC.quiz = quiz
            answerVC.currentQuestionIndex = currentQuestionIndex
            answerVC.score = score
            answerVC.totalQuestions = quiz?.questions.count ?? 0
        }
    }
}

// MARK: - UITableViewDataSource
extension QuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz?.questions[currentQuestionIndex].answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        guard let question = quiz?.questions[currentQuestionIndex] else { return cell }
        
        cell.textLabel?.text = question.answers[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        // Highlight selected answer
        if indexPath.row == selectedAnswerIndex {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = .white
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension QuestionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedAnswerIndex = indexPath.row
        submitButton.isEnabled = true
        submitButton.alpha = 1.0
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
