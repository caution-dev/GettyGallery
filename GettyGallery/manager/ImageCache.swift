//
//  ImageCache.swift
//  GettyGallery
//
//  Created by juhee on 05/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "ImageCache"
        cache.countLimit = 20
        return cache
    }()
    
    private let ioQueue = DispatchQueue(label: "diskCache")
    
    /**
     MemoryCache에 캐싱된 이미지를 불러옵니다.
     
     - Parameters:
        - url: 캐싱된 메모리 값
     - Returns: memory caching에서 불러온 UIImage
     */
    func loadImageFromMemoryCache(url: URL) -> UIImage? {
        return memoryCache.object(forKey: url.cachingKey) as? UIImage
    }
    
    /**
     Image를 Memory에 Caching 합니다.
     
     - Parameters:
         - image: Memory에 캐싱할 UIImage
         - url: caching key로 사용될 url
     */
    func cachingToMemory(image: UIImage, url: URL) {
        memoryCache.setObject(
            image,
            forKey: url.cachingKey
        )
    }
    
    /**
     MemoryCaching 합니다.
     
     - Parameters:
        - image: Memory에 캐싱할 UIImage
        - url: caching key로 사용될 url
        - cost: caching cost
     */
    func cachingToMemory(image: UIImage, url: URL, cost: Int) {
        memoryCache.setObject(
            image,
            forKey: url.cachingKey,
            cost: cost
        )
    }
    
    /**
     DiskCache에 캐싱된 이미지가 있는지 체크합니다.
     
     - Parameters:
        - url: caching key로 사용될 url
     - Returns: disk caching에서 불러온 UIImage
     */
    func loadImageFromDiskCache(url: URL) -> UIImage? {
        return FileManager.default.loadImageFile(path: diskPath(for: url))
    }
    
    /**
     DiskCaching에 사용할 path을 정합니다.
     
     - Parameters:
        - url: imageName
     - Returns: disk caching 으로 사용될 path
     */
    func diskPath(for url: URL) -> String {
        let diskPaths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.cachesDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true
            )
        let cacheDirectory = diskPaths[0] as NSString
        return cacheDirectory.appendingPathComponent("\(url.cachingKey)")
    }
    
    /**
     image를 DiskCaching 합니다.
     
     UIImage를 0.7 compression하여 저장합니다.
     
     - Parameters:
        - image: Disk에 캐싱할 UIImage
        - url: caching key로 사용될 url
     */
    func cachingToDisk(image: UIImage, url: URL) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        let imagePath = self.diskPath(for: url)
        ioQueue.async {
            FileManager.default.writeData(data: imageData, path: imagePath)
        }
    }
    
}
