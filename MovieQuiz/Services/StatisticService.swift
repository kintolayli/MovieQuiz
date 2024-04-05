//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 02.04.2024.
//

import Foundation

protocol StatisticService {
    var total: Int { get }
    var correct: Int { get }
    var gamesCount: Int { get }
    var totalAccuracy: Double { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}


final class StatisticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            let value = self.total + newValue
            userDefaults.set(value, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            let value = self.correct + newValue
            userDefaults.set(value, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            if total != 0 {
                return Double(correct) / Double(total) * 100
            }
            return Double(0)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(
            correct: count,
            total: amount,
            date: Date()
        )
        
        gamesCount += 1
        total = amount
        correct = count
        
        if !bestGame.isBetterThan(another: newGame) {
            self.bestGame = newGame
        }
    }
}
