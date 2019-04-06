//
//  String+NSRegularExpression.swift
//  GettyGallery
//
//  Created by juhee on 05/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import Foundation

extension String {
    /**
     주어진 정규식 패턴과 일치하는 문자열을 찾아서 배열로 넘깁니다.
     *
     - Parameters:
     - regex : 정규식으로 사용할 String 패턴
     - Returns:
     - 정규식에 부합하는 문자열 배열
     */
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("😭😭😭invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
