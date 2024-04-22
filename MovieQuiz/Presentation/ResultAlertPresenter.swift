//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import UIKit


class ResultAlertPresenter {
    
    var viewController: MovieQuizViewController

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }
    
    func show(in viewController: MovieQuizViewController, model: AlertModel) {
        self.viewController = viewController
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        self.viewController.present(alert, animated: true, completion: nil)
    }
}
