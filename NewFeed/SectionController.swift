//
//  SectionController.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/30.
//

import Foundation
import UIKit

protocol SectionController: BaseComponent, UITableViewDelegate, UITableViewDataSource {
    func registerCellClass(_ tableView: UITableView)
}
