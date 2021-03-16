//
//  Storyboarded.swift
//  kocheng
//
//  Created by Robihamanto on 2021/3/16.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName name: String, _ bundle: Bundle?) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName name: String, _ bundle: Bundle? = nil) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: name, bundle: bundle)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
