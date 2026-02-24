//
//  SunSectionView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

final class SunSectionView: UIView {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let sunriseView: SunInfoCardView = SunInfoCardView()
    private let sunsetView: SunInfoCardView = SunInfoCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStack)
        
        containerStack.addArrangedSubview(sunriseView)
        containerStack.addArrangedSubview(sunsetView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(sunInfo: WeatherState.SunInfo) {
        sunriseView.configure(title: NSLocalizedString("sun_sunrise", comment: "").uppercased(),
                              time: sunInfo.sunrise,
                          systemImageName: "sunrise.fill")
        
        sunsetView.configure(title: NSLocalizedString("sun_sunset", comment: "").uppercased(),
                             time: sunInfo.sunset,
                         systemImageName: "sunset.fill")
    }
}
