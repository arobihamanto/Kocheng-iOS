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
    
    @IBOutlet weak var todayCatImageView: UIImageView!
    
    private var loadingView: LoadingView!
    private var viewModel: TodayViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingView()
        bindViewModel()
        setupViews()
    }
    
    private func configureLoadingView() {
        loadingView = LoadingView(style: .medium)
        loadingView.center = view.center
        view.addSubview(loadingView)
    }
    
    private func bindViewModel() {
        let service = TheCatService()
        let useCase = FetchCatImagesUseCase(repository: CatRepository(theCatAPIService: service))
        viewModel = TodayViewModel(fetchCatImagesUseCase: useCase)
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        todayCatImageView.isUserInteractionEnabled = true
        todayCatImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        viewModel.input.viewDidLoad()
    }
}
