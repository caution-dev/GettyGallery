//
//  URL+.swift
//  GettyGallery
//
//  Created by juhee on 06/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import Foundation

extension URL {
    
    var cachingKey: AnyObject {
        return self.absoluteString.hashValue as AnyObject
    }
}
