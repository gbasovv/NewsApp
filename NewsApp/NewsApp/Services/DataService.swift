//
//  DataService.swift
//  NewsApp
//
//  Created by George on 9.09.21.
//

import UIKit

class DataService {
    private init() { }
    static let shared = DataService()

    let defaults = UserDefaults.standard

    var saveNews: [Article] {
        get {
            if let data = defaults.value(forKey: "Article") as? Data {
                return try! PropertyListDecoder().decode([Article].self, from: data)
            }
            return [Article]()
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "Article")
            }
        }
    }
}
