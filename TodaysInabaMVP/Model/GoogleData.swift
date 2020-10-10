//
//  GoogleData.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Foundation

struct GoogleData: Codable {
    var items:[Items]
}

struct Items: Codable {
    var title: String
    var link: String //画像のURL（リクエストパラメータでsearchTypeをimageに指定していると"link"に記事URLではなく画像のURLが返ってくる。
    var image: Url //記事のURL
}

struct Url: Codable {
    var contextLink: String
}




