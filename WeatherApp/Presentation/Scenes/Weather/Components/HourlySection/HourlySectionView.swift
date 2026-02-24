//
//  HourlySectionView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 23.02.2026.
//

import UIKit

final class HourlySectionView: UIView {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        let emptyView = UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stackView.addArrangedSubview(emptyView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(hourlyForecast : [WeatherState.HourlyWeather]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        hourlyForecast.forEach { hourWeather in
            let card = HourlyWeatherCardView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            card.configure(
                time: hourWeather.time,
                imageNameURL: hourWeather.iconName,
                temperature: hourWeather.temperature,
            )
            
            stackView.addArrangedSubview(card)
        }
    }
}
