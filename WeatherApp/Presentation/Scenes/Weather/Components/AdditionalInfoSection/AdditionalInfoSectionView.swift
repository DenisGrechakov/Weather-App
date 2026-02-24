//
//  AdditionalInfoSectionView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

final class AdditionalInfoSectionView: UIView {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let uvInfoView: InfoCardView = InfoCardView()
    private let windInfoView: InfoCardView = InfoCardView()
    private let humidityInfoView: InfoCardView = InfoCardView()
    
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
        
        containerStack.addArrangedSubview(uvInfoView)
        containerStack.addArrangedSubview(windInfoView)
        containerStack.addArrangedSubview(humidityInfoView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(additionalInfo: WeatherState.AdditionalInfo) {
        uvInfoView.configure(title: NSLocalizedString("additional_uv_index", comment: "").uppercased(),
                             value: additionalInfo.uvIndex,
                             systemImageName: "sun.max.fill")
        
        windInfoView.configure(title: NSLocalizedString("additional_wind", comment: "").uppercased(),
                               value: additionalInfo.wind,
                               systemImageName: "wind")
        humidityInfoView.configure(title: NSLocalizedString("additional_humidity", comment: "").uppercased(),
                                   value: additionalInfo.humidity,
                                   systemImageName: "drop.fill")
    }
}
