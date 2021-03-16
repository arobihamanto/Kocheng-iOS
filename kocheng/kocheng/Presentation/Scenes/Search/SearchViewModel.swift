//
//  SearchViewModel.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModelActions {
    let showSearch: () -> Void
}

protocol SearchViewModelInput {
    func viewDidLoad()
}

protocol SearchViewModelOutput {
    var isLoading: BehaviorRelay<Bool> { get set }
    var imageURL: PublishSubject<String> { get set }
    var errorMessage: PublishSubject<String> { get set }
}

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput  {
    private let actions: SearchViewModelActions?
    
    var input : SearchViewModelInput { return self }
    var output: SearchViewModelOutput { return self }
    
    var imageURL: PublishSubject<String>
    var isLoading: BehaviorRelay<Bool>
    var errorMessage: PublishSubject<String>
    
    private let fetchCatImagesUseCase: FetchCatImagesUseCase
    
    init(actions: SearchViewModelActions? = nil, fetchCatImagesUseCase: FetchCatImagesUseCase) {
        self.actions = actions
        self.isLoading = isLoadingProperty
        self.imageURL = imageURLProperty
        self.errorMessage = errorMessageProperty
        self.fetchCatImagesUseCase = fetchCatImagesUseCase
    }
    
    func viewDidLoad() {
        fetchCatImages()
    }
    
    private func fetchCatImages() {
        self.isLoadingProperty.accept(true)
        fetchCatImagesUseCase.execute { [weak self] result in
            switch result {
            case .success(let response):
                self?.isLoadingProperty.accept(false)
                self?.imageURL.onNext(response.first?.url ?? "")
            case .failure(let error):
                self?.isLoadingProperty.accept(false)
                self?.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
    private var isLoadingProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var imageURLProperty: PublishSubject<String> = PublishSubject()
    private var errorMessageProperty: PublishSubject<String> = PublishSubject()
    
}
