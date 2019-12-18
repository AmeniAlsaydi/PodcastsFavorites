//
//  PodcastAPIClient.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/16/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import Foundation

struct PodcastAPIClient {
    
    static func getPodcasts(searchQuery: String, completion: @escaping (Result<[Podcast], AppError>)-> ()) {
        
        let endpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL))) //  assigning the competion handler a failure
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let podcasts = results.results
                    completion(.success(podcasts))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
                
            }
        }
    }
    
    static func getPodcastUsingId(podId: Int, completion: @escaping (Result<[Podcast], AppError>)-> ()) {
        
        let endpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(podId)"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL))) //  assigning the competion handler a failure
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let podcasts = search.results
                    
                    completion(.success(podcasts))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
                
            }
        }
    }
    
    
    
    static func getFavorites(completion: @escaping (Result<[FavoritePodcast], AppError>)-> ()) {
        let endpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL))) // assigning the competion handler a failure
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let favorites = try JSONDecoder().decode([FavoritePodcast].self, from: data)
                    
                    completion(.success(favorites))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
    static func postFavorite(favoritedPodcast: FavoritePodcast, completion: @escaping (Result<Bool, AppError>)-> ()){
        
        let endpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: endpointURL) else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(favoritedPodcast)
            
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = data
            
            request.httpMethod = "POST"
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.encodingError(error)))
        }
    }
}

