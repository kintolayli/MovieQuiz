//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Ilya Lotnik on 16.04.2024.
//

import Foundation


protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        let APIKey = "k_zcuw1ytf"
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/\(APIKey)") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                }
                catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
                
        }
    }
}
