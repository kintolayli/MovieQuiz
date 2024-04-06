//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 02.04.2024.
//

import Foundation


struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(another: GameRecord) -> Bool {
        return self.correct > another.correct
    }
}
