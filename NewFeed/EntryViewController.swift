//
//  EntryViewController.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(onCamera)),
            UIBarButtonItem(title: "Feed", style: .plain, target: self, action: #selector(onFeed)),
        ]
    }

    @objc
    func onFeed() {
        navigationController?.pushViewController(TopContainerViewController(initialSection: 1), animated: true)
    }

    @objc
    func onCamera() {
        navigationController?.pushViewController(TopContainerViewController(initialSection: 0), animated: true)
    }
}
