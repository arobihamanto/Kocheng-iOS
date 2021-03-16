//
//  TheCatAPI.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Moya

enum TheCatAPI {
    case fetchCatImages
}

extension TheCatAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1") else {
            fatalError("FAILED: https://api.thecatapi.com/v1")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchCatImages:
            return "/images/search"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchCatImages:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        //let params: [String: Any] = [:]
        
        switch self {
        case .fetchCatImages:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["x-api-key"] = "55f1df77-4498-4324-a23f-8eab52b47b2d"
        
        switch self {
        case .fetchCatImages:
            return headers
        }
        
    }
    
}
