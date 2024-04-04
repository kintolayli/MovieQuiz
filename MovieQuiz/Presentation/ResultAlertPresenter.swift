//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import UIKit


class ResultAlertPresenter {
    
    var alertModel: AlertModel
    var viewController: MovieQuizViewController

    init(viewController: MovieQuizViewController, result: QuizResultsViewModel, completion: @escaping () -> Void) {
        self.viewController = viewController
        
        self.alertModel = AlertModel (
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: completion
        )
    }
    
    func present() {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: self.alertModel.buttonText, style: .default) { [ weak self ] _ in
            self?.alertModel.completion()
        }
        
        alert.addAction(action)
        
        self.viewController.present(alert, animated: true, completion: nil)
    }
}
