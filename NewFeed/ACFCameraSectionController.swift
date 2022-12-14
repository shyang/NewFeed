//
//  CameraSectionController.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class ACFCameraSectionController : ACFBaseComponent, ACFSectionController {
    func registerCellClass(_ tableView: UITableView) {
        tableView.register(ACFCameraCell.self, forCellReuseIdentifier: "CameraCell")
    }
}

extension ACFCameraSectionController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CameraCell", for: indexPath)
        cell.contentView.backgroundColor = .red
        cell.selectionStyle = .none
        return cell
    }

}

extension ACFCameraSectionController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return round(UIScreen.main.bounds.height * 0.8)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cameraCell = cell as? ACFCameraCell {
            cameraCell.cellWillAppear()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cameraCell = cell as? ACFCameraCell {
            cameraCell.cellWillDisappear()
        }
    }
}
