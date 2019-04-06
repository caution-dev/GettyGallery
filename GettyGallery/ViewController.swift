//
//  ViewController.swift
//  GettyGallery
//
//  Created by juhee on 04/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gettyTableView: UITableView!
    
    private var gettyImages: [GettyImage] = []
    private let tableViewCellReuseIdentifier: String = "getty_table_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetcher = URLFetcher()
        fetcher.loadHTML(success: { [weak self] (images) in
            DispatchQueue.main.async {
                self?.gettyImages = images
                self?.gettyTableView.reloadData()
            }
        }, errorHandler: {
            print("fail!")
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gettyImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: tableViewCellReuseIdentifier,
            for: indexPath
            ) as? GettyImageTableViewCell else {
                preconditionFailure("dequeue cell with reuse identifier failed")
        }
        cell.bind(source: gettyImages[indexPath.row])
        return cell
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if let url = gettyImages[$0.row].src {
                ImageManager.shared.fetchImage(url: url, completion: nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({
            if let url = gettyImages[$0.row].src {
                ImageManager.shared.cancelLoadImage(url: url)
            }
        })
    }
}
