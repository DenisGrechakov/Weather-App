//
//  DailyWeatherRowView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 23.02.2026.
//

import UIKit
import Kingfisher

final class DailyWeatherRowView: UIView {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Color.text.primary
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.text.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Color.text.secondary
        label.textAlignment = .right
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Color.text.primary
        label.textAlignment = .right
        return label
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let tempStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Color.background.secondary
        layer.cornerRadius = 16
        
        addSubview(containerStack)
        
        tempStack.addArrangedSubview(minTempLabel)
        tempStack.addArrangedSubview(maxTempLabel)
        
        containerStack.addArrangedSubview(dayLabel)
        containerStack.addArrangedSubview(iconView)
        containerStack.addArrangedSubview(UIView())
        containerStack.addArrangedSubview(tempStack)
        
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(day: String,
                   imageNameURL: String,
                   minTemp: String,
                   maxTemp: String) {
        dayLabel.text = day
        
        if let url = URL(string: "https:\(imageNameURL)") {
            iconView.kf.setImage(with: url)
        }else {
            iconView.image = UIImage(systemName: imageNameURL)
        }
        
        minTempLabel.text = minTemp
        maxTempLabel.text = maxTemp
    }
}
