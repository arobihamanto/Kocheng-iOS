//
//  SearchViewController.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import RxSwift
import RxCocoa

class SearchViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchResultImageView: UIImageView!
    
    private var loadingView: LoadingView!
    private var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    static func create(with viewModel: SearchViewModel) -> SearchViewController {
        let viewController = self.instantiate(storyboardName: "Main")
        viewController.viewModel = viewModel
        return viewController
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
                self?.searchResultImageView
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
    }
    
    private func configureLoadingView() {
        loadingView = LoadingView(style: .medium)
        loadingView.center = view.center
        view.addSubview(loadingView)
    }
    
}
