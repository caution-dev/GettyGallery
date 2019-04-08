//
//  URLFetcher.swift
//  GettyGallery
//
//  Created by juhee on 04/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class URLFetcher {
    
    private let basicURL: String = "https://www.gettyimagesgallery.com"
    
    func loadGettyImages(success: @escaping ([GettyImage]) -> Void, errorHandler: @escaping ()->Void) {
        guard let url: URL = URL(string: basicURL + "/collection/sasha/") else { preconditionFailure() }
        
        if let cachedContents = cachedResponse(forKey: url.absoluteString) {
            let gettyImages = self.mapToGettyImages(cachedContents)
            success(gettyImages)
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            if let error = error {
                errorHandler()
                print("Error Occurred!!")
                print(error.localizedDescription)
                return
            }
            guard let data = data,
                let htmlString = String(data: data, encoding: .utf8) else {
                    return
            }
            let imageContents = self.getImageContents(htmlString)
            let cashContents = self.cachedResponse(forKey: url.absoluteString)
            
            if cashContents == nil || cashContents?.hashValue != imageContents.hashValue {
                self.cachingResponse(forKey: url.absoluteString, contents: imageContents)
                let gettyImages = self.mapToGettyImages(imageContents)
                success(gettyImages)
            }
        }
        dataTask.resume()
    }
    
    private func getImageContents(_ response: String) -> String {
        let startPattern: String = "<div class=\"grid masonry-grid masonry-view\">"
        let endPattern: String = "<footer class=\"entry-footer\">"
        guard let slicedDocuments = response.components(separatedBy: startPattern).last else {
            preconditionFailure("couldn't find matched with startPattern")
        }
        guard let contents = slicedDocuments.components(separatedBy: endPattern).first else {
            preconditionFailure("couldn't find matched with endPattern")
        }
        return contents
    }
    
    private func mapToGettyImages(_ contents: String) -> [GettyImage] {
        var result: [GettyImage] = []
        
        let imagePattern: String = "(?<=<img class=\"jq-lazy\" data-src=\")([^\"]+)"
        let images = contents.matches(for: imagePattern)
        
        let titlePattern: String = "(?<=<h5 class=\"image-title\">)([^</]+)"
        let titles = contents.matches(for: titlePattern)
        
        for i in 0..<imagePattern.count {
            // url이 유효하지 않을 경우를 제외합니다.
            if let url = URL(string: images[i]) {
                result.append(GettyImage.init(src: url, name: titles[i]))
            }
        }
        return result
    }
    
    private func cachingResponse(forKey key: String, contents: String) {
            UserDefaults.standard.set(contents, forKey: key)
    }
    
    private func cachedResponse(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
