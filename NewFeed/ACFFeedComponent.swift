//
//  ListComponent.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class ACFFeedComponent: ACFBaseComponent {

    var initialSection = 0
    var sectionControllers: [ACFSectionController] = []
    let firstCellHeight: CGFloat = round(UIScreen.main.bounds.height * 0.8)
    var dragBeginY: CGFloat = 0

    required init(context: SimpleContainer) {
        super.init(context: context)

        if let data = context.resolveObject(ACFSharedModel.self) {
            initialSection = data.initialSection
        }

        let controllers: [ACFSectionController.Type] = initialSection == 0 ? [
            ACFCameraSectionController.self, // 相机
            ACFFeedSectionController.self, // 时刻
        ] : [
            ACFFeedSectionController.self,
        ]
        sectionControllers = controllers.map { $0.init(context: context) }
    }

    lazy var tableView: UITableView = {
        let v = UITableView()
        v.dataSource = self
        v.delegate = self
        sectionControllers.forEach { $0.registerCellClass(v) }
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()

    override func componentDidAppear() {
        // 对 camera section 懒加载
        if initialSection > 0 {
            let c = ACFCameraSectionController(context: context)
            c.registerCellClass(tableView)
            sectionControllers.insert(c, at: 0)
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
            dragBeginY = firstCellHeight
        }
    }

    override func componentDidLoad() {
        controller?.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ACFFeedComponent : UIScrollViewDelegate {

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

extension ACFFeedComponent : UITableViewDelegate {

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

extension ACFFeedComponent : UITableViewDataSource {

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
