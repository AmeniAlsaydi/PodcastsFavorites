//
//  FavoritesDetailController.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/17/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import UIKit

class FavoritesDetailController: UIViewController {

    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackId: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    var favoritePodcast: FavoritePodcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        podcastImage.layer.cornerRadius = podcastImage.frame.width/20
    }
    
    
    func updateUI() {
        
        guard let thePodcast = favoritePodcast else {
            fatalError("check prepare for segue")
        }
        
        trackNameLabel.text = thePodcast.collectionName
        trackId.text = thePodcast.trackId.description
        podcastImage.getImage(with: thePodcast.artworkUrl600) { [weak self] (result) in
            switch result {
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
