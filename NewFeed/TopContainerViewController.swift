//
//  ViewController.swift
//  NewFeed
//
//  Created by shaohua yang on 2022/8/26.
//

import UIKit
import SnapKit

class TopContainerViewController: UIViewController {

    var context = SimpleContainer()
    var components: [BaseComponent] = []

    required init(initialSection: Int) {
        super.init(nibName: nil, bundle: nil)

        let data = SharedModel()
        data.initialSection = initialSection

        context.register(data, forType: SharedModel.self)
        context.register(self, forType: UIViewController.self)

        components = [
            ListComponent.self, // 时刻列表
            // NavigationComponent.self 导航栏
        ].map { $0.init(context: context) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        components.forEach { $0.componentDidLoad() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        components.forEach { $0.componentWillAppear() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        components.forEach { $0.componentDidAppear() }
    }
}
