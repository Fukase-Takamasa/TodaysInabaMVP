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
    
    var randomQuery = ["かっこいい", "かわいい", "眼鏡", "へそ", "97年"]
    var toolBar = UIToolbar()
    var datePicker = UIDatePicker()
    
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //空の[String]配列の保存先を予め作っておく
        UserDefaults.standard.set([String](), forKey: "imageUrlStrings")
        
        dateTextField.delegate = self
        dateTextField.returnKeyType = .done
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        
        setupToolBar()
        setupDatePicker()
    }
    
    func searchRequest() {
        
        HUD.show(.progress)
        
        //APIリクエスト
        let provider = MoyaProvider<API>()
        provider.request(
            .CustomSearch(
                query: "稲葉浩志" + randomQuery.randomElement()!,
                startIndex: Int.random(in: 1...10))) { (result) in
            
            HUD.hide()
            
            switch result {
            case let .success(moyaResponse):
                do {
                    self.nameTextField.text = ""
                    
                    let googleData = try! JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
                    let resultImageUrl = googleData.items[Int.random(in: 0...9)].link
                    
                    //UserDefaults内の画像URL配列を取得し、先頭に追加して保存し直す
                    guard var imageUrlStrings = UserDefaults.standard.value(forKey: "imageUrlStrings") as? [String] else {
                        print("取得失敗")
                        return}
                    imageUrlStrings.insert(resultImageUrl, at: 0)
                    UserDefaults.standard.set(imageUrlStrings, forKey: "imageUrlStrings")
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "ResultViewController", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    //次画面へ画像URLを受け渡し
                    vc.resultImageUrl = resultImageUrl
                    
                    self.present(vc, animated: true)
                }catch {
                    print("error")
                }
            case let .failure(error):
                print(error.localizedDescription)
                
                let alert = UIAlertController(title: "通信に失敗しました。", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                
                break
            }
        }
    }
    
    @IBAction func tappedHistoryButton(_ sender: Any) {
        self.present(UIHostingController(rootView: HistoryView()), animated: true, completion: nil)
    }
    
    func setupToolBar() {
        toolBar.sizeToFit()
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spacerItem, doneItem], animated: true)
    }
    
    @objc func done() {
        view.endEditing(true)
    }
    
    func setupDatePicker() {
        //        if #available(iOS 14.0, *) {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.frame = dateTextField.frame
        dateTextField.backgroundColor = .clear
        dateTextField.addSubview(datePicker)
        dateTextField.placeholder = ""
        //        }
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = .current
        datePicker.tintColor = UIColor(red: 33/255, green: 173/255, blue: 182/255, alpha: 1)
        dateTextField.inputView = datePicker
        dateTextField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dateTextField.inputAccessoryView = toolBar
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //        if #available(iOS 14.0, *) {
        if !(nameTextField.text?.isEmpty ?? true) {
            print("名前の入力が完了しました")
            searchRequest()
        }
        //        }else {
        //            if !(dateTextField.text?.isEmpty ?? true) && !(nameTextField.text?.isEmpty ?? true) {
        //                print("日付と名前両方の入力が完了しました")
        //                searchRequest()
        //            }
        //        }
        
        return true
    }
}

