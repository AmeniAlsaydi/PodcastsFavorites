//
//  PodcastDetailController.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/17/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import UIKit

class PodcastDetailController: UIViewController {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackId: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var podcastImage: UIImageView!
    
    var podcast: Podcast?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        podcastImage.layer.cornerRadius = podcastImage.frame.width/20
    }
    func updateUI() {
        guard let thePodcast = podcast else {
            return
        }
        
        trackId.text = thePodcast.trackId.description
        trackNameLabel.text = thePodcast.collectionName
        artistName.text = thePodcast.artistName
        genreLabel.text = thePodcast.primaryGenreName
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
        
        if thePodcast.favoritedBy != nil {
            let heartImage = UIImage(systemName: "heart.fill")
            self.favoriteButton.setImage(heartImage, for: .normal)
            self.favoriteButton.isEnabled = false
        }
        
    }
    

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        let heartImage = UIImage(systemName: "heart.fill")
        favoriteButton.setImage(heartImage, for: .normal)
        sender.isEnabled = false
        
        guard let thePodcast = podcast else { // podcast is nil 
            fatalError("issue with prepare for segue")
        }
        
        //create a instance of Podcast
        
        let favoritedPodcast = Podcast(trackId: thePodcast.trackId, artworkUrl600: thePodcast.artworkUrl600, collectionName: thePodcast.collectionName, primaryGenreName: thePodcast.primaryGenreName, artistName: thePodcast.artistName, favoritedBy: "Bob Bobby")
        
        
        PodcastAPIClient.postFavorite(favoritedPodcast: favoritedPodcast) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                self?.showAlert(title: "Failed to post answer", message: "\(appError)")
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Added to Favorites", message: "🎧 + ♥️") { alert in self?.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
}
