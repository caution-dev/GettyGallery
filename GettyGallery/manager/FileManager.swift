//
//  FileManager.swift
//  GettyGallery
//
//  Created by juhee on 05/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

extension FileManager {
    /**
     Disk에 데이터를 저장합니다.
     
     - Parameters:
        - data: 저장할 Data
        - path: 저장 Path
     */
    func writeData(data: Data, path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Disk에서 Image File을 불러옵니다.
     
     - Parameters:
        - path: 파일을 불러올 path
     - Returns: 파일에서 읽어온 UIImage
     */
    func loadImageFile(path: String) -> UIImage? {
        if FileManager.default.fileExists(atPath: path) {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}
