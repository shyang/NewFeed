//
//  ViewController.swift
//  NewFeed
//
//  Created by shaohua yang on 2022/8/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0

        let v = UITableView()
        v.dataSource = self
        v.delegate = self
        v.decelerationRate = .fast
        v.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    let firstCellHeight: CGFloat = round(UIScreen.main.bounds.height * 0.8)
    var dragBeginY: CGFloat = 0
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return firstCellHeight
        }

        // 4:3
        if indexPath.row % 2 == 0 {
            return view.bounds.width / 3 * 4
        }
        // 1:1
        return view.bounds.width
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        print(String(format: "h %.0f v %+.2f target %4.0f begin %.0f", firstCellHeight, velocity.y, targetContentOffset.pointee.y, dragBeginY))

        let targetY = targetContentOffset.pointee.y

        scrollView.decelerationRate = .fast
        if dragBeginY < firstCellHeight {
            if targetY >= firstCellHeight * 0.5 || velocity.y > 0.1 {
                targetContentOffset.pointee.y = firstCellHeight
            } else {
                targetContentOffset.pointee.y = 0
            }
        } else if dragBeginY == firstCellHeight {
            if targetY < firstCellHeight * 0.5 || velocity.y < -0.1 {
                targetContentOffset.pointee.y = 0
            } else if targetY < firstCellHeight {
                targetContentOffset.pointee.y = firstCellHeight
            } else {
                scrollView.decelerationRate = .normal
            }
        } else if dragBeginY > firstCellHeight {
            if targetY < firstCellHeight {
                targetContentOffset.pointee.y = firstCellHeight
            } else {
                scrollView.decelerationRate = .normal
            }
        }
        dragBeginY = targetContentOffset.pointee.y
    }

}

extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = .red
        } else if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = .green
        } else {
            cell.contentView.backgroundColor = .gray
        }
        cell.textLabel?.text = String(format: "Row %d", indexPath.row)
        return cell
    }
}
