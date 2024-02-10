//
//  ViewModel.swift
//  CatStories
//
//  Created by Kyrylo Derkach on 10.02.2024.
//

import Foundation
import UIKit
import RxSwift

class ViewModel {
    
    let disposeBag = DisposeBag()
    
    let loadedImage = PublishSubject<UIImage>()
    let loadedText = PublishSubject<String>()
    let loadedElements = PublishSubject<(UIImage, String)>()
    
    let isLoadingFinished = PublishSubject<Void>()
    
    init() {
        Observable.zip(
            self.loadedImage,
            self.loadedText
        )
        .subscribe(self.loadedElements)
        .disposed(by: disposeBag)
    }
    
    func generateCat() {
        CatLoader.loadImage()
            .subscribe(
                onSuccess: { [weak self] generatedImage in
                    self?.loadedImage.onNext(generatedImage)
                },
                onFailure: { error in
                    print("Error loading image: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        CatLoader.loadStory()
            .subscribe(
                onSuccess: { [weak self] generatedStory in 
                    self?.loadedText.onNext(generatedStory)
                },
                onFailure: { error in
                    print("Error loading story: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
}
