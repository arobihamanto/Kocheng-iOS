//
//  Cat.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/15.
//

import Foundation

// MARK: - Cat
struct Cat: Codable {
    let categories: [Category]?
    let id: String?
    let url: String?
    let width, height: Int?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
}
