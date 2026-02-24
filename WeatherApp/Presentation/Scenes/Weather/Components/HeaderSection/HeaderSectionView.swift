//
//  HeaderSectionView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

final class HeaderSectionView: UIView {
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background.secondary
        view.layer.cornerRadius = 48
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.buttons.fill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 64, weight: .bold)
        label.textColor = Color.text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let feelslikeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = Color.text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Color.text.secondary
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
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
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(iconContainerView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(feelslikeLabel)
        stackView.addArrangedSubview(detailsLabel)
        
        iconContainerView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconContainerView.widthAnchor.constraint(equalToConstant: 96),
            iconContainerView.heightAnchor.constraint(equalToConstant: 96),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor, constant: -4),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(headerInfo: WeatherState.HeaderInfo) {
        temperatureLabel.text = headerInfo.temperature
        feelslikeLabel.text = String(format: NSLocalizedString("header_feels_like", comment: ""), headerInfo.feelsLike)
        detailsLabel.text = "\(headerInfo.country), \(headerInfo.region), \(headerInfo.name)"
        
        if let url = URL(string: "https:\(headerInfo.iconURL)") {
            iconImageView.kf.setImage(with: url)
        }else {
            iconImageView.image = UIImage(systemName: headerInfo.iconURL)
        }
    }
}
