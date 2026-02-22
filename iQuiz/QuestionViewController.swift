//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/22/2026.
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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🟢 QuestionViewController loaded")
        print("📚 Quiz: \(quiz?.title ?? "nil")")
        print("📊 Total questions: \(quiz?.questions.count ?? 0)")
        
        setupUI()
        setupTableView()
        setupSwipeGestures()
        loadCurrentQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次页面出现时重新加载当前问题
        loadCurrentQuestion()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = quiz?.title ?? "Quiz"
        
        submitButton.layer.cornerRadius = 8
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitleColor(.gray, for: .disabled)
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
    }
    
    private func loadCurrentQuestion() {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else {
            print("❌ Failed to load question: quiz is nil or index out of range")
            return
        }
        
        let question = quiz.questions[currentQuestionIndex]
        
        // 更新 UI
        questionLabel.text = question.text
        title = "\(quiz.title) - Question \(currentQuestionIndex + 1) of \(quiz.questions.count)"
        
        // 重置选择状态
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        
        // 刷新表格
        tableView.reloadData()
        
        print("📋 Loaded question \(currentQuestionIndex + 1): \(question.text)")
        print("📝 Answer options: \(question.answers)")
    }
    
    // MARK: - Actions
    @IBAction func submitTapped() {
        print("🔵 Submit button tapped")
        
        guard let quiz = quiz else {
            print("❌ quiz is nil")
            return
        }
        
        guard let selectedIndex = selectedAnswerIndex else {
            print("❌ No answer selected")
            return
        }
        
        guard currentQuestionIndex < quiz.questions.count else {
            print("❌ Question index out of range")
            return
        }
        
        let question = quiz.questions[currentQuestionIndex]
        let isCorrect = selectedIndex == question.correctAnswerIndex
        
        print("📝 Question: \(question.text)")
        print("👉 Selected answer: \(selectedIndex) - \(question.answers[selectedIndex])")
        print("✅ Correct answer: \(question.correctAnswerIndex) - \(question.answers[question.correctAnswerIndex])")
        print("🎯 Is correct: \(isCorrect)")
        
        if isCorrect {
            score += 1
            print("⭐ Score: \(score)")
        }
        
        print("➡️ Performing segue: ShowAnswer")
        performSegue(withIdentifier: "ShowAnswer", sender: (question, selectedIndex, isCorrect))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("🔄 prepareForSegue: \(segue.identifier ?? "nil")")
        
        if segue.identifier == "ShowAnswer",
           let answerVC = segue.destination as? AnswerViewController,
           let (question, selectedIndex, isCorrect) = sender as? (Question, Int, Bool) {
            
            print("📤 Passing data to AnswerViewController:")
            print("  - Question: \(question.text)")
            print("  - Selected index: \(selectedIndex)")
            print("  - Is correct: \(isCorrect)")
            print("  - Current score: \(score)")
            print("  - Current index: \(currentQuestionIndex)")
            print("  - Total questions: \(quiz?.questions.count ?? 0)")
            
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
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else {
            return 0
        }
        return quiz.questions[currentQuestionIndex].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else {
            cell.textLabel?.text = "Error"
            return cell
        }
        
        let question = quiz.questions[currentQuestionIndex]
        let answer = question.answers[indexPath.row]
        
        cell.textLabel?.text = answer
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
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
        
        print("✅ Selected answer at row: \(indexPath.row)")
        
        selectedAnswerIndex = indexPath.row
        submitButton.isEnabled = true
        submitButton.alpha = 1.0
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Swipe Gestures (Extra Credit)
extension QuestionViewController {
    
    private func setupSwipeGestures() {
        // Swipe Right = Submit
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Swipe Left = Abandon quiz
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Add hint label
        addSwipeHint()
    }
    
    private func addSwipeHint() {
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
    
    @objc func handleSwipeRight() {
        print("👉 Swipe right detected")
        if submitButton.isEnabled {
            submitTapped()
        }
    }
    
    @objc func handleSwipeLeft() {
        print("👈 Swipe left detected")
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
}
