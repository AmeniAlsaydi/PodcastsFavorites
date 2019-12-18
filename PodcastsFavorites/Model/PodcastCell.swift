//
//  podcastCell.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/17/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        podcastImage.layer.cornerRadius = podcastImage.frame.width/13
    }
    
    func configurePodcastCell(for podcast: Podcast) {
        trackName.text = podcast.collectionName
        artist.text = podcast.artistName
        
        podcastImage.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "exclamationmark.square")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImage.image = image
                }
            }
        }
        
    }
    
    func configureFavCell(for favoritePod: Podcast) {
        trackName.text = favoritePod.collectionName
        
        podcastImage.getImage(with: favoritePod.artworkUrl600) { [weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "exclamationmark.square")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImage.image = image
                }
            }

        }
    }
    
    
}
