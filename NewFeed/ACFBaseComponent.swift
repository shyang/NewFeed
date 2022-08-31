//
//  BaseComponent.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import Foundation
import UIKit

class ACFBaseComponent : NSObject {

    private(set) weak var context: SimpleContainer!
    private(set) weak var controller: UIViewController!

    required init(context: SimpleContainer) {
        self.context = context
        controller = context.resolveObject(UIViewController.self)
    }

    func componentDidLoad() {
    }

    func componentWillAppear() {
    }

    func componentDidAppear() {
    }
}
