//
//  ACFPagingComponent.swift
//  NewFeed
//
//  Created by shaohua on 2022/8/31.
//

import UIKit

protocol ACFPagingService : UIScrollViewDelegate {
    func update(contentY: CGFloat)
}

class ACFPagingComponent: ACFBaseComponent, ACFPagingService {
    let firstCellHeight: CGFloat = round(UIScreen.main.bounds.height * 0.8)
    var dragBeginY: CGFloat = 0

    func update(contentY: CGFloat) {
        dragBeginY = contentY
    }

    required init(context: SimpleContainer) {
        super.init(context: context)

        context.register(self, forType: ACFPagingService.self)
    }
}

extension ACFPagingComponent : UIScrollViewDelegate {
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
