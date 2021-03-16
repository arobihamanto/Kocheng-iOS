//
//  FetchCatImagesUseCase.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Foundation

protocol FetchCatImagesUseCaseType {
    func execute(completion: @escaping(Result<[Cat], Error>) -> Void)
}

final class FetchCatImagesUseCase: FetchCatImagesUseCaseType {
    
    private let repository: CatRepositoryType
    
    init(repository: CatRepositoryType) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Cat], Error>) -> Void) {
        repository.fetchCatImages { result in
            switch result {
            case .success(let cats):
                completion(.success(cats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

