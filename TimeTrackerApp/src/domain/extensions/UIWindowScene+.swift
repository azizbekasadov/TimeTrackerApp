//
//  UIWindowScene+.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import UIKit

extension UIWindowScene {
    var keyWindowRootViewController: UIViewController? {
        windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController?
            .topMostViewController()
    }
}
