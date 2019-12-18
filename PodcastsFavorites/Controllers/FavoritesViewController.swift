//
//  FavoritesViewController.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/17/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    var favorites = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadFavorites()
        tableView.delegate = self
        configureRefreshControl()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? PodcastDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("couldnt get detailVC or indexPath")
        }
        
        detailVC.podcast = favorites[indexPath.row]
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(loadFavorites), for: .valueChanged)
    }
    
    @objc func loadFavorites() {
        PodcastAPIClient.getFavorites { [weak self] (result) in
            
            DispatchQueue.main.async {
              self?.refreshControl.endRefreshing()
            }
            
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let favorites):
                DispatchQueue.main.async {
                    self?.favorites = favorites.filter {$0.favoritedBy == "Bob Bobby"}
                }
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? PodcastCell else {
            fatalError("could not get downcast to custom cell")
        }
        
        let podcast = favorites[indexPath.row]
        cell.configureFavCell(for: podcast)
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}


// TODO:
    // show if a podcast has already been favorited in the podcast table view


