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

class ResultViewController: UIViewController, StoryboardInstantiatable {

    var viewModel: ResultViewModel?
        
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        
        guard let resultImageUrl = viewModel?.resultImageUrl else {return}
        
        imageView.kf.setImage(with: URL(string: resultImageUrl), completionHandler:  { _ in
            self.imageView.hideSkeleton()
        })
        
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
