//
//  FavoritePodcast.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/17/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import Foundation

struct FavoritePodcast: Codable {
    
    let trackId: Int
    let favoritedBy: String
    let collectionName: String
    let artworkUrl600: String
}
