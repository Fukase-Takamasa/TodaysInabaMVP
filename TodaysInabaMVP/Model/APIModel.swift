//
//  APIModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import Moya
import RxSwift

final class APIModel {
    
    private static let provider = MoyaProvider<API>()
    
    static func getTodaysInabaImages() -> Observable<GoogleData> {
        return provider.rx.request(
            .CustomSearch(
                query: "稲葉浩志" + ["かっこいい", "かわいい", "眼鏡", "へそ", "97年"].randomElement()!,
                startIndex: Int.random(in: 1...10)))
            .map { response in
                
                try! JSONDecoder().decode(GoogleData.self, from: response.data)
                
            }.asObservable()
    }
    
}
