//
//  ViewController.swift
//  CatStories
//
//  Created by Kyrylo Derkach on 10.02.2024.
//

import UIKit
import RxSwift

class CatsViewController: UIViewController {
    
    let vm = ViewModel()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catStoryLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.center = catImageView.center
        
        vm.isLoadingFinished
            .subscribe(
                onNext: { [weak self] in
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                        self?.loadingIndicator.removeFromSuperview()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        vm.loadedElements
            .subscribe(
                onNext: { [weak self] img, text in
                    self?.vm.isLoadingFinished.onNext(())
                    DispatchQueue.main.async {
                        self?.catImageView.image = img
                        self?.catStoryLabel.text = text
                    }
                }
            )
            .disposed(by: disposeBag)
    }

    @IBAction func onGeneratePressed(_ sender: UIButton) {
        catImageView.image = nil
        catStoryLabel.text = "Loading cat. Please wait..."
        
        catImageView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        vm.generateCat()
    }
    
}

