//
//  ViewController.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/09/27.
//

import UIKit
import RxSwift
import RxCocoa
import Instantiate
import InstantiateStandard
import PKHUD
import SwiftUI

class ViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    let viewModel = TopViewModel()
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var historyBotton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker()
        nameTextField.returnKeyType = .done
        
        //input
        nameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] element in
                self?.viewModel.userName.onNext(element)
            }).disposed(by: disposeBag)
        
        //output
        viewModel.todaysInabaResponse
            .subscribe(onNext: { [weak self] element in
                print("vc_response: \(element)")
                
                let resultImageUrl = element.items[Int.random(in: 0...9)].link
                
                let vc = ResultViewController.instantiate()
                vc.viewModel = ResultViewModel(resultImageUrl: resultImageUrl)
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: {
                    
                    self?.nameTextField.text = ""
                    //UDに保存
                    UserDefaultsModel.saveUrl(value: resultImageUrl)
                    
                })
                
            }).disposed(by: disposeBag)
        
        //通信状態に応じてインジケータを表示
        viewModel.isFetching
            .subscribe(onNext: { element in
                element ? HUD.show(.progress) : HUD.hide()
            }).disposed(by: disposeBag)
        
        //other
        historyBotton.rx.tap
            .subscribe(onNext: { [weak self] element in
                self?.present(UIHostingController(rootView: HistoryView()), animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.frame = dateTextField.frame
        dateTextField.backgroundColor = .clear
        dateTextField.addSubview(datePicker)
        dateTextField.placeholder = ""
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = .current
        datePicker.tintColor = UIColor(red: 33/255, green: 173/255, blue: 182/255, alpha: 1)
        dateTextField.inputView = datePicker
        dateTextField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
