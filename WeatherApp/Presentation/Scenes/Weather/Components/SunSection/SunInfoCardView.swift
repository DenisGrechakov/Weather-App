//
//  SunInfoCardView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

final class SunInfoCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Color.text.secondary
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = Color.text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.text.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
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
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(timeLabel)
        
        iconView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(title: String,
                   time: String,
                   systemImageName: String) {
        titleLabel.text = title
        timeLabel.text = time
        iconView.image = UIImage(systemName: systemImageName)
    }
}
