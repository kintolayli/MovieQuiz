//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 25.03.2024.
//

import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    private var moviesSorted: [MostPopularMovie] = []
    private let randomFloatArray: [Float] = [-0.2, 0, 0.2]
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [ weak self ] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    if mostPopularMovies.errorMessage != "Invalid API Key" {
                        self.movies = mostPopularMovies.items
                        self.moviesSorted = movies.sorted { $0.rating < $1.rating }
                    } else {
                        self.delegate?.didFailToLoadImage(with: mostPopularMovies.errorMessage)
                    }
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
           do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
           } catch {
               let message = "Failed to load image"
               print(message)
               
               DispatchQueue.main.async { [weak self] in
                   self?.delegate?.didFailToLoadImage(with: message)
               }
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let meanRating = (Float(moviesSorted.first!.rating)! + Float(moviesSorted.last!.rating)!) / 2
            let meanRatingRound = round(meanRating * 10) / 10

            let randomFloat = randomFloatArray.randomElement()
            let randomPhrase = ["больше", "меньше"].randomElement()
            var meanRatingSomeRandom = meanRatingRound + randomFloat!
            
            if meanRatingSomeRandom == rating {
                meanRatingSomeRandom += randomFloat!
            }

            let text = "Рейтинг этого фильма \(randomPhrase!) чем \(meanRatingSomeRandom)?"
            let correctAnswer: Bool
            
            print("rating - \(rating)")
            print("meanRatingSomeRandom - \(meanRatingSomeRandom)")
            
            if randomPhrase == "больше" {
                correctAnswer = rating > meanRatingSomeRandom
            } else {
                correctAnswer = rating < meanRatingSomeRandom
            }
            
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
