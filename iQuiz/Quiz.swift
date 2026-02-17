//
//  Quiz.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/16/2026.
//

import Foundation

struct Quiz {
    let title: String
    let description: String
    let iconName: String
}

struct QuizData {
    static let sampleQuizzes = [
        Quiz(title: "Mathematics",
             description: "Test your math skills with numbers and equations",
             iconName: "function"),
        Quiz(title: "Marvel Super Heroes",
             description: "How well do you know the Marvel Universe?",
             iconName: "star"),
        Quiz(title: "Science",
             description: "Explore the mysteries of science, from physics to chemistry",
             iconName: "flask")
    ]
}
