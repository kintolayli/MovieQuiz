//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 31.03.2024.
//

import UIKit


struct AlertModel {
    let accessibilityId: String
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
