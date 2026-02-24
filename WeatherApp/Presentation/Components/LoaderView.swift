//
//  LoaderView.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 21.02.2026.
//

import UIKit
import Lottie

class LoaderView: UIView {
    
    // MARK: - UI
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.background.primary
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.background.secondary.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    //loader
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loader")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("loader_updating", comment: "")
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.text.primary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(blurView)
        addSubview(containerView)
        
        containerView.addSubview(animationView)
        containerView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Blur fills entire screen
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Container centered
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 220),
            
            // Indicator
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 80),
            animationView.heightAnchor.constraint(equalToConstant: 80),
            
            // Label
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Public API
    
    func show(in view: UIView) {
        frame = view.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alpha = 0
        
        view.addSubview(self)
        animationView.play()
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { [weak self] _ in
            self?.animationView.stop()
            self?.removeFromSuperview()
        }
    }
}
