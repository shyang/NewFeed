//
//  CameraCell.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class ACFCameraCell: UITableViewCell {

    let cameraVC = ACFCameraViewController()
    var viewLoaded = false

    func cellWillAppear() {
        if (!viewLoaded) {
            viewLoaded = true

            addSubview(cameraVC.view)
            cameraVC.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            cameraVC.viewWillAppear(false)
        }
    }

    func cellWillDisappear() {
        cameraVC.viewWillDisappear(false)
    }
}
