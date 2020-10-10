//
//  UserDefaultsModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/10.
//

import Foundation

final class UserDefaultsModel {
    
    //MARK: - Properties
    private static let ud = UserDefaults.standard
    
    //MARK: - Methods
    static func saveUrl(value: String) {
        guard var imageUrlArr = ud.value(forKey: "imageUrlArr") as? [String] else {
            print("imageUrlArrが存在しないので空の配列を作成")
            UserDefaultsModel.ud.setValue([String](), forKey: "imageUrlArr")
            return
        }
        imageUrlArr.insert(value, at: 0)
        ud.setValue(imageUrlArr, forKey: "imageUrlArr")
        print("set")
    }
    
    static func getUrlArr() -> [String] {
        if let imageUrlArr = ud.value(forKey: "imageUrlArr") as? [String] {
            return imageUrlArr
        }else {
            print("imageUrlArr取得失敗")
            return []
        }
        print("get")
    }
}
