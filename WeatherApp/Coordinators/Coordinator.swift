//
//  Coordinator.swift
//  MoodDiary
//
//  Created by Гречаков Денис on 10.11.2025.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
