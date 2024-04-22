//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage(with message: String)
}
