//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import UIKit


class ResultAlertPresenter {
    
    var result: QuizResultsViewModel?
    var viewController: MovieQuizViewController
    var completion: () -> Void
    var alertModel: AlertModel?

    init(viewController: MovieQuizViewController, completion: @escaping () -> Void) {
        self.viewController = viewController
        self.completion = completion
    }
    
    func present() {
        guard let result = self.result else { return }
        
        self.alertModel = AlertModel (
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: self.completion
        )
        
        guard let alertModel = self.alertModel else { return }
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: self.alertModel?.buttonText, style: .default) { [ weak self ] _ in
            self?.alertModel?.completion()
        }
        
        alert.addAction(action)
        
        self.viewController.present(alert, animated: true, completion: nil)
    }
}
