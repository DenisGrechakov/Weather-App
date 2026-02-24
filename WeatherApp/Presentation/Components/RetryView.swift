//
//  RetryView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 24.02.2026.
//

import UIKit

final class RetryView: UIView {
    
    // MARK: - Public
    var onRetry: (() -> Void)?
    
    // MARK: - UI
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "retry"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("retry_title", comment: "")
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("retry_message", comment: "")
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let retryButton: FillButton = {
        let button = FillButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 24
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = Color.background.primary
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(retryButton)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 180),
            iconImageView.heightAnchor.constraint(equalToConstant: 180),
            
            retryButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapRetry() {
        onRetry?()
    }
    
    // MARK: - Public API
    func show(in view: UIView) {
        frame = view.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alpha = 0
        
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
