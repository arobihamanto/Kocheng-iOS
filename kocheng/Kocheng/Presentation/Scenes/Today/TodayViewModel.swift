//
//  TodayViewModel.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/15.
//

import Foundation
import RxSwift
import RxCocoa

struct TodayViewModelActions {
    let showSearch: () -> Void
}

protocol TodayViewModelInput {
    func viewDidLoad()
}

protocol TodayViewModelOutput {
    var isLoading: BehaviorRelay<Bool> { get set }
    var imageURL: PublishSubject<String> { get set }
    var errorMessage: PublishSubject<String> { get set }
}

protocol TodayViewModelType {
    var input: TodayViewModelInput { get }
    var output: TodayViewModelOutput { get }
}

class TodayViewModel: TodayViewModelType, TodayViewModelInput, TodayViewModelOutput  {
    private let actions: TodayViewModelActions?
    
    var input : TodayViewModelInput { return self }
    var output: TodayViewModelOutput { return self }
    
    var imageURL: PublishSubject<String>
    var isLoading: BehaviorRelay<Bool>
    var errorMessage: PublishSubject<String>
    
    private let fetchCatImagesUseCase: FetchCatImagesUseCase
    
    init(actions: TodayViewModelActions? = nil, fetchCatImagesUseCase: FetchCatImagesUseCase) {
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
