//
//  CatRepository.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Foundation

final class CatRepository: CatRepositoryType {
    
    private let theCatAPIService: TheCatService
    
    init(theCatAPIService: TheCatService) {
        self.theCatAPIService = theCatAPIService
    }
    
    func fetchCatImages(completion: @escaping (Result<[Cat], Error>) -> Void) {
        theCatAPIService.fetchCatImages { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
