//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import UIKit


class AlertPresenter {
    
    var alertModel: AlertModel
    var viewController: MovieQuizViewController

    init(viewController: MovieQuizViewController, result: QuizResultsViewModel) {
        self.viewController = viewController
        
        self.alertModel = AlertModel (
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: {}
        )
    }
    
    func present() {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: self.alertModel.buttonText, style: .default) { _ in
            self.viewController.startOver()
        }
        
        alert.addAction(action)
        
        self.viewController.present(alert, animated: true, completion: nil)
    }
}
