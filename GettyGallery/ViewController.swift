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
    @IBOutlet weak var loadingView: UIView!
    
    private var gettyImages: [GettyImage] = []
    private let tableViewCellReuseIdentifier: String = "getty_table_cell"
    private let noDataCellReuseIdentifier: String = "no_data_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        URLFetcher().loadGettyImages(success: { (images) in
            DispatchQueue.main.async { [weak self] in
                self?.gettyImages = images
                self?.gettyTableView.reloadData()
                self?.loadingView.isHidden = true
            }
        }, errorHandler: {
            DispatchQueue.main.async { [weak self] in
                let alertVC = UIAlertController(title: "통신 오류", message: "데이터를 가져오는 데 실패했습니다.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self?.present(alertVC, animated: true, completion: nil)
                self?.loadingView.isHidden = true
            }
        })
    }
    
    private func setUpTableView() {
        gettyTableView.register(UITableViewCell.self, forCellReuseIdentifier: noDataCellReuseIdentifier)
    }
    
    private func moveToDetail(imageUrl: URL) {
        let detailViewController = DetailViewController()
        detailViewController.bind(imageUrl: imageUrl)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gettyImages.isEmpty {
            return 1
        }
        return gettyImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gettyImages.isEmpty {
            let noDataCell = tableView.dequeueReusableCell(withIdentifier: noDataCellReuseIdentifier, for: indexPath)
            noDataCell.textLabel?.text = "데이터가 없습니다."
            return noDataCell
        }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: tableViewCellReuseIdentifier,
            for: indexPath
            ) as? GettyImageTableViewCell else {
                preconditionFailure("dequeue cell with reuse identifier : \(tableViewCellReuseIdentifier) failed")
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let gettyImage = gettyImages[indexPath.row]
        if let imageUrl = gettyImage.src {
            let detailViewController = DetailViewController()
            detailViewController.title = gettyImage.name
            detailViewController.bind(imageUrl: imageUrl)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
