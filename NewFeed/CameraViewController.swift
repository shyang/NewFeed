//
//  CameraViewController.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self, "did load")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print(self, "will appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print(self, "will disappear")
    }
}
