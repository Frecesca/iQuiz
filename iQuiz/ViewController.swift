//
//  ViewController.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/22/2026.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let toolbar = UIToolbar()
    let quizzes = QuizData.sampleQuizzes
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupToolbar()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        title = "iQuiz"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupToolbar() {
        let settingsButton = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [flexibleSpace, settingsButton, flexibleSpace]
        toolbar.sizeToFit()
        
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    // MARK: - Actions
    @objc func settingsButtonTapped() {
        let alertController = UIAlertController(
            title: "Settings",
            message: "Settings go here",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("🔄 prepareForSegue: \(segue.identifier ?? "nil")")
        
        if segue.identifier == "StartQuiz",
           let questionVC = segue.destination as? QuestionViewController,
           let selectedQuiz = sender as? Quiz {
            
            print("📤 Passing quiz to QuestionViewController: \(selectedQuiz.title)")
            print("📊 Number of questions: \(selectedQuiz.questions.count)")
            
            // ✅ 只设置 quiz 属性，QuestionViewController 会通过 quiz.questions 获取问题
            questionVC.quiz = selectedQuiz
            // ❌ 不要设置 questionVC.questions，因为这个属性不存在
            // questionVC.questions = selectedQuiz.questions  // 删除这行！
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as? QuizTableViewCell else {
            return UITableViewCell()
        }
        
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedQuiz = quizzes[indexPath.row]
        print("👉 Selected quiz: \(selectedQuiz.title)")
        print("📊 Number of questions: \(selectedQuiz.questions.count)")
        
        performSegue(withIdentifier: "StartQuiz", sender: selectedQuiz)
    }
}
