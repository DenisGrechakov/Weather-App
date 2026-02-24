//
//  HourlyWeatherCardView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 23.02.2026.
//

import UIKit
import Kingfisher

final class HourlyWeatherCardView: UIView {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Color.text.secondary
        label.textAlignment = .center
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.text.primary
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Color.text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(temperatureLabel)
        
        iconView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(time: String,
                   imageNameURL: String,
                   temperature: String) {
        timeLabel.text = time
        
        if let url = URL(string: "https:\(imageNameURL)") {
            iconView.kf.setImage(with: url)
        }else {
            iconView.image = UIImage(systemName: imageNameURL)
        }
        temperatureLabel.text = temperature
    }
}
