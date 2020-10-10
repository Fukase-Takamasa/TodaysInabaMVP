//
//  ViewController.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/09/27.
//

import UIKit
import Instantiate
import InstantiateStandard
import PKHUD
import SwiftUI

class ViewController: UIViewController, StoryboardInstantiatable {
    
    private var presenter: TopPresenter?

    private var datePicker = UIDatePicker()
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        setupDatePicker()
        
        presenter = TopPresenter(listener: self)
    }
    
    
    
    @IBAction func tappedHistoryButton(_ sender: Any) {
        self.present(UIHostingController(rootView: HistoryView()), animated: true, completion: nil)
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

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if !(nameTextField.text?.isEmpty ?? true) {
            print("名前の入力が完了しました")
            
            //PresenterにAPIリクエスト
            presenter?.requestAPI()
        }
        return true
    }
}

extension ViewController: TopPresenterInterface {
    
    func successResponse(url: String) {
        let vc = ResultViewController.instantiate()
        vc.viewModel = ResultViewModel(resultImageUrl: url)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    func errorResponse(error: Error) {
        let alert = UIAlertController(title: "通信に失敗しました。",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
}
