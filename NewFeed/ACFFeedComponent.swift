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

            let paging = context.resolveObject(ACFPagingService.self)
            paging?.update(contentY: tableView.contentOffset.y)
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
        let paging = context.resolveObject(ACFPagingService.self)
        paging?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
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
