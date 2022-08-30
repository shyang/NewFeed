//
//  FeedSectionController.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import UIKit

class FeedSectionController : NSObject {

}

extension FeedSectionController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = .green
        } else {
            cell.contentView.backgroundColor = .gray
        }
        cell.textLabel?.text = String(format: "Row %d", indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
}

extension FeedSectionController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 4:3
        if indexPath.row % 2 == 0 {
            return tableView.bounds.width / 3 * 4
        }
        // 1:1
        return tableView.bounds.width
    }
}
