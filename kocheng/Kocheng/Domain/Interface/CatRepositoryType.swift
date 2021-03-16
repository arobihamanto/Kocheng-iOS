//
//  CatRepositoryType.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Foundation

protocol CatRepositoryType {
    
    func fetchCatImages(completion: @escaping(Result<[Cat], Error>) -> Void)
    
}
