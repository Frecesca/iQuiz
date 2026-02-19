//
//  Quiz.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/19/2026.
//

import Foundation

struct Quiz {
    let title: String
    let description: String
    let iconName: String
    let questions: [Question]
}

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

// Test data
struct QuizData {
    static let sampleQuizzes = [
        Quiz(
            title: "Mathematics",
            description: "Test your math skills with numbers and equations",
            iconName: "function",
            questions: [
                Question(
                    text: "What is 2 + 2?",
                    answers: ["3", "4", "5", "6"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is 5 × 3?",
                    answers: ["8", "15", "10", "20"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is 10 ÷ 2?",
                    answers: ["3", "4", "5", "6"],
                    correctAnswerIndex: 2
                )
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            description: "How well do you know the Marvel Universe?",
            iconName: "star",
            questions: [
                Question(
                    text: "Who is Iron Man?",
                    answers: ["Steve Rogers", "Tony Stark", "Bruce Banner", "Thor"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is Captain America's shield made of?",
                    answers: ["Steel", "Vibranium", "Adamantium", "Titanium"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        Quiz(
            title: "Science",
            description: "Explore the mysteries of science",
            iconName: "flask",
            questions: [
                Question(
                    text: "What is H₂O?",
                    answers: ["Oxygen", "Hydrogen", "Water", "Salt"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "What planet is known as the Red Planet?",
                    answers: ["Venus", "Jupiter", "Mars", "Saturn"],
                    correctAnswerIndex: 2
                )
            ]
        )
    ]
}
