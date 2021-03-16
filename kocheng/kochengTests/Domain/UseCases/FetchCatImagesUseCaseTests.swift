//
//  FetchCatImagesUseCaseTests.swift
//  kochengTests
//
//  Created by Robihamanto on 2021/3/16.
//

@testable import Kocheng
import XCTest

class FetchCatImagesUseCaseTests: XCTestCase {
    
    static var cats: [Cat]?
    
    override class func setUp() {
        let filename = "cat_list_response_mock"
        let catsMockJSON = DataProvider.jsonData(from: filename)!
        cats = try! JSONDecoder().decode([Cat].self, from: catsMockJSON)
    }
    
    enum FetchError: Error {
        case decodeError
    }
    
    struct CatRepositoryMock: CatRepositoryType {
        var result: Result<[Cat], Error>
        
        func fetchCatImages(completion: @escaping (Result<[Cat], Error>) -> Void) {
            completion(result)
        }
        
    }
    
    func testFetchCatImagesSuccess() {
        // given
        let repository = CatRepositoryMock(result: .success(FetchCatImagesUseCaseTests.cats!))
        let useCase = FetchCatImagesUseCase(repository: repository)
        
        // when
        var cats: [Cat]?
        var error: Error?
        useCase.execute { result in
            switch result {
            case .success(let response):
                cats = response
            case .failure(let errorResponse):
                error = errorResponse
            }
        }
        
        //then
        XCTAssertTrue(cats?.count == 5)
        XCTAssertNil(error)
    }
    
    func testFetchCatImagesFailure() {
        // given
        let repository = CatRepositoryMock(result: .failure(FetchError.decodeError))
        let useCase = FetchCatImagesUseCase(repository: repository)
        
        // when
        var cats: [Cat]?
        var error: Error?
        useCase.execute { result in
            switch result {
            case .success(let response):
                cats = response
            case .failure(let errorResponse):
                error = errorResponse
            }
        }
        
        //then
        XCTAssertNil(cats)
        XCTAssertNotNil(error)
    }
    
    
}
