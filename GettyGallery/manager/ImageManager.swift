//
//  ImageManager.swift
//  GettyGallery
//
//  Created by juhee on 05/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class ImageManager {
    
    typealias ImageLoadCompletion = (UIImage) -> Void
    
    static let shared = ImageManager()
    private var tasks = [URLSessionTask]()
    
    private init() {}
    
    /**
     해당 URL의 이미지를 패칭합니다.
     
     캐싱된 이미지가 없다면 이미지 다운로드를 진행합니다.
     
     - Parameters:
        - url : 이미지 source url
        - completion : 이미지 로드가 종료된 후 할 작업
     */
    func fetchImage(url: URL, completion: ImageLoadCompletion?) {
        if let image = loadImageFromCache(url: url) {
            completion?(image)
            return
        }
        requestImage(url: url, completion: completion)
    }
    
    /**
     해당 URL의 이미지를 불러옵니다.
     
     메모리 캐시를 탐색하여 이미지를 불러옵니다.
     디스크 캐시를 탐색하여 이미지를 불러옵니다. 디스크 캐시에 이미지를 찾았다면 메모리에 캐싱합니다.
     캐싱된 이미지를 찾을 수 없을 경우 nil을 반환합니다.
     
     - parameter url : 이미지 source url
     - Returns: 캐시에서 load한 이미지
     */
    private func loadImageFromCache(url: URL) -> UIImage? {
        if let image = ImageCache.shared.loadImageFromMemoryCache(url: url) {
            return image
        }
        
        if let image = ImageCache.shared.loadImageFromDiskCache(url: url) {
            ImageCache.shared.cachingToMemory(image: image, url: url)
            return image
        }
        return nil
    }
    
    /**
     해당 URL의 이미지를 URLSession을 통해 다운로드하고 캐싱합니다.
     
     불러온 이미지는 메모리/디스크 캐시에 저장합니다.
     - Parameters:
     - url : 이미지 source url
     - completion : 이미지 로드가 종료된 후 할 작업
     */
    private func requestImage(url: URL, completion: ImageLoadCompletion?) {
        guard tasks.first(where: { $0.originalRequest?.url == url }) == nil else { return }
        let imageLoadTask = URLSession.shared.dataTask(with: url) {
            data, _, error in
            if error == nil {
                if let data = data, let image = UIImage(data: data) {
                    ImageCache.shared.cachingToMemory(image: image, url: url, cost: data.count)
                    ImageCache.shared.cachingToDisk(image: image, url: url)
                    
                    if let completion = completion {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                    
                }
            }
        }
        imageLoadTask.resume()
        tasks.append(imageLoadTask)
    }
    
    /**
     해당 URL의 URLSessionTask를 cancel합니다.
     
     tasks 작업 배열에서 작업이 존재한다면 이 작업을 캔슬하고 종료합니다.
     - Parameters:
     - url : 이미지 source url
     */
    func cancelLoadImage(url: URL) {
        guard let taskIndex = tasks.index(where: {
            $0.originalRequest?.url == url
        }) else { return }
        let myTask = tasks[taskIndex]
        myTask.cancel()
        tasks.remove(at: taskIndex)
    }
}
