//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 02.04.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var total: Int { get }
    var correct: Int { get }
    
    func store(correct count: Int, total amount: Int)
}


final class StatisticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
            let total = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }

            return total
        }

        set {
            let value = self.total + newValue
            guard let data = try? JSONEncoder().encode(value) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
            let correct = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }

            return correct
        }

        set {
            let value = self.correct + newValue
            guard let data = try? JSONEncoder().encode(value) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {

            return Double(correct) / Double(total) * 100
        }
    }
    
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
            let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }

            return gamesCount
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
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

