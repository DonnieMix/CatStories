//
//  CatLoader.swift
//  CatStories
//
//  Created by Kyrylo Derkach on 10.02.2024.
//

import Foundation
import RxSwift
import UIKit

struct CatLoader {
    
    static func loadImage() -> Single<UIImage> {
        return Single<UIImage>.create { single in
            let task = URLSession.shared.dataTask(
                with: URL(string: Const.catImageLink.rawValue)!
            ) { data, _, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let data, let uiImage = UIImage(data: data) else {
                    single(.failure(URLError(URLError.cannotDecodeRawData)))
                    return
                }
                
                single(.success(uiImage))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    static func loadStory() -> Single<String> {
        return Single<String>.create { single in
            let task = URLSession.shared.dataTask(
                with: URL(string: Const.catStoryLink.rawValue)!
            ) { data, _, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let data,
                      let json = try? JSONSerialization.jsonObject(with: data),
                      let dictionary = json as? [String: Any],
                      let story = dictionary["fact"] as? String
                else {
                    single(.failure(URLError(URLError.cannotParseResponse)))
                    return
                }
                
                single(.success(story))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
}
