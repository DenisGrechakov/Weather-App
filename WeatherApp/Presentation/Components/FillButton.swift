//
//  FillButton.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

class FillButton: UIButton {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setTitleColor(Color.buttons.fillText, for: .normal)
        backgroundColor = Color.buttons.fill
        titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
