//
//  Podcast.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/16/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import Foundation

struct PodcastSearch: Decodable {
    let results: [Podcast]
}

struct Podcast: Codable {
    let trackId: Int
    let artworkUrl600: String
    let collectionName: String
    let primaryGenreName: String?
    let artistName: String?
    let favoritedBy: String?
    
}
