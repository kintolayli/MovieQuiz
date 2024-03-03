//
//  QuizStateModels.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 03.03.2024.
//

import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct AnswerResultViewModel {
    let result: Bool
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
