//
//  LoadingView.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import Foundation
import UIKit

class LoadingView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        hidesWhenStopped = true
        startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isVisible: Bool? {
        didSet {
            isHidden = !isVisible!
        }
    }
    
}
