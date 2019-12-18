//
//  ViewController.swift
//  PodcastsFavorites
//
//  Created by Amy Alsaydi on 12/16/19.
//  Copyright © 2019 Amy Alsaydi. All rights reserved.
//

import UIKit

class PodcastsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var podcasts = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = "swift" {
        didSet {
            DispatchQueue.main.async {
                self.loadPodcasts()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        searchBar.delegate = self
        loadPodcasts()
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? PodcastDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not get detailVC or indexPath")
        }
        detailVC.podcast = podcasts[indexPath.row]
       }
    
    private func loadPodcasts() {
        PodcastAPIClient.getPodcasts(searchQuery: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let podcasts):
                self?.podcasts = podcasts
                
                
            }
        } // this is the clousre the API client takes in as a parameter
        // result is the result of the network helper????
    }
}


extension PodcastsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
            fatalError("could not downcast to custom podcastCell")
        }
        let podcast = podcasts[indexPath.row]
        
        cell.configurePodcastCell(for: podcast)
        
        return cell 
    }
}

extension PodcastsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else {
            return
        }
        
        guard !searchText.isEmpty else {
            loadPodcasts()
            return
        }
        
        searchQuery = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "no"
        
    }
}

extension PodcastsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
