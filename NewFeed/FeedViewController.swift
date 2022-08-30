//
//  ViewController.swift
//  NewFeed
//
//  Created by shaohua yang on 2022/8/26.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {

    var initialSection = 0
    var sectionControllers: [UITableViewDelegate & UITableViewDataSource] = []

    init(initialSection: Int) {
        super.init(nibName: nil, bundle: nil)

        self.initialSection = initialSection

        if initialSection == 0 {
            sectionControllers = [
                CameraSectionController(),
                FeedSectionController(),
            ]
        } else {
            sectionControllers = [
                FeedSectionController(),
            ]
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let v = UITableView()
        v.dataSource = self
        v.delegate = self
        v.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        v.register(CameraCell.self, forCellReuseIdentifier: "CameraCell")
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 对 camera section 懒加载
        if initialSection > 0 {
            sectionControllers.insert(CameraSectionController(), at: 0)
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
            dragBeginY = firstCellHeight
        }
    }

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

extension FeedViewController : UIScrollViewDelegate {

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

extension FeedViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectionControllers[indexPath.section].tableView!(tableView, heightForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sectionControllers[indexPath.section].tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sectionControllers[indexPath.section].tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
}

extension FeedViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionControllers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionControllers[section].tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sectionControllers[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
}
