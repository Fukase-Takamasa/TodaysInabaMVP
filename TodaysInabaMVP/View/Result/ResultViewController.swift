//
//  ResultViewController.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/09.
//

import UIKit
import Kingfisher
import SkeletonView
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

class ResultViewController: UIViewController, StoryboardInstantiatable {

    let disposeBag = DisposeBag()
    var viewModel: ResultViewModel?
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toTopPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        
        guard let resultImageUrl = viewModel?.resultImageUrl else {return}
        
        imageView.kf.setImage(with: URL(string: resultImageUrl), completionHandler:  { _ in
            self.imageView.hideSkeleton()
        })
        
        //other
        toTopPageButton.rx.tap
            .subscribe(onNext: { [weak self] element in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }
    
}
