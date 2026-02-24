//
//  DailySectionView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 23.02.2026.
//

import UIKit

final class DailySectionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: NSLocalizedString("daily_forecast_title", comment: ""), 3)
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Color.text.secondary
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
        addSubview(containerStack)
        
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(dailyForecast: [WeatherState.DailyWeather]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        dailyForecast.forEach { dailyWeather in
            let row = DailyWeatherRowView()
            row.translatesAutoresizingMaskIntoConstraints = false
            row.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            row.configure(
                day: dailyWeather.day,
                imageNameURL: dailyWeather.iconName,
                minTemp: dailyWeather.minTemp,
                maxTemp: dailyWeather.maxTemp,
            )
            
            stackView.addArrangedSubview(row)
        }
    }
}
