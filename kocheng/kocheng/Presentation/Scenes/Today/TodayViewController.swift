//
//  ViewController.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/15.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class TodayViewController: UIViewController{
    
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var todayCatImageView: UIImageView!
    
    private var loadingView: LoadingView!
    private var viewModel: TodayViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModel()
        bindViewModel()
    }
    
    private func initViewModel() {
        let service = TheCatService()
        let actions = TodayViewModelActions(showSearch: navigateToSearch)
        let useCase = FetchCatImagesUseCase(repository: CatRepository(theCatAPIService: service))
        viewModel = TodayViewModel(actions: actions, fetchCatImagesUseCase: useCase)
    }
    
    private func bindViewModel() {
        let inputs = viewModel.input
        let outputs = viewModel.output
        
        inputs.viewDidLoad()
        
        outputs
            .isLoading
            .bind(to: loadingView.rx.isVisible)
            .disposed(by: disposeBag)
        
        outputs
            .imageURL
            .subscribe { [weak self] imageURL in
                self?.todayCatImageView
                    .kf
                    .setImage(with: URL(string: imageURL))
            }.disposed(by: disposeBag)
        
        outputs
            .errorMessage
            .subscribe { error in
                print(error)
            }.disposed(by: disposeBag)
    }
    
    private func setupViews() {
        configureLoadingView()
        
        searchBarButtonItem
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.navigateToSearch()
            }.disposed(by: disposeBag)

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        todayCatImageView.isUserInteractionEnabled = true
        todayCatImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureLoadingView() {
        loadingView = LoadingView(style: .medium)
        loadingView.center = view.center
        view.addSubview(loadingView)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        viewModel.input.viewDidLoad()
    }
    
    func navigateToSearch() {
        let service = TheCatService()
        let repository = CatRepository(theCatAPIService: service)
        let fetchImageUseCase = FetchCatImagesUseCase(repository: repository)
        let viewModel = SearchViewModel(fetchCatImagesUseCase: fetchImageUseCase)
        let vc = SearchViewController.create(with: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
