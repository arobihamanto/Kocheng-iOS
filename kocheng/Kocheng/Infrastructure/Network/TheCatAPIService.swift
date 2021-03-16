//
//  TheCatAPIService.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Moya

protocol TheCatServiceType {
    func fetchCatImages(completion: @escaping (Result<[Cat], Error>) -> Void)
}

class TheCatService: TheCatServiceType {
    
    private let provider = MoyaProvider<TheCatAPI>(plugins: [NetworkLoggerPlugin()])

    func fetchCatImages(completion: @escaping (Result<[Cat], Error>) -> Void) {
        provider.request(.fetchCatImages) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let data = try JSONDecoder().decode([Cat].self, from: filteredResponse.data)
                    completion(.success(data))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
