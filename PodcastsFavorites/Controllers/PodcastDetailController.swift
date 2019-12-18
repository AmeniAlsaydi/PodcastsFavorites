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
    var favoritePodcast: FavoritePodcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavPodInfo()
        updatePodcastUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        podcastImage.layer.cornerRadius = podcastImage.frame.width/20
    }
    
   
    
    func updatePodcastUI() {
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
        
    }
    
    func getFavPodInfo() {
        
        guard let favoritedPodcast = favoritePodcast else {
            return 
                   //fatalError("check prepare for segue")
               }
        
        PodcastAPIClient.getPodcastUsingId(podId: favoritedPodcast.trackId) { [weak self] (result) in
            switch result {
                
            case .failure(let appError):
                print("issue with getFavPodInfo function: \(appError)")
            case .success(let podcasts):
                self?.podcast = podcasts.first
                DispatchQueue.main.async {
                    self?.updatePodcastUI()
                    let heartImage = UIImage(systemName: "heart.fill")
                    self?.favoriteButton.setImage(heartImage, for: .normal)
                    self?.favoriteButton.isEnabled = false
                }
                
            }
        }
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        let heartImage = UIImage(systemName: "heart.fill")
        favoriteButton.setImage(heartImage, for: .normal)
        sender.isEnabled = false
        
        guard let thePodcast = podcast else {
            fatalError("issue with prepare for segue")
        }
        
        //create a instance of FavoritePodcast
        
        let favoritedPodcast = FavoritePodcast(trackId: thePodcast.trackId, favoritedBy: "Bob Bobby", collectionName: thePodcast.collectionName, artworkUrl600: thePodcast.artworkUrl600)
        
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
