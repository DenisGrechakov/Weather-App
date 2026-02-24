//
//  OnboardingViewController.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit
import Combine
import Lottie

@MainActor
final class OnboardingViewController: ViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    var onPermissionGranted: (() -> Void)?
    var onFinihed: (() -> Void)?
    
    private lazy var viewModel: OnboardingViewModel = {
        let vm = OnboardingViewModelImpl()
        
        vm.effects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] effect in
                self?.sideEffect(effect: effect)
            }
            .store(in: &cancellables)
        
        return vm
    }()
    
    //ThermometerHot
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "ThermometerHot")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let startButton: FillButton = {
        let button = FillButton()
        button.setTitle(NSLocalizedString("onboarding_start_button", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("onboarding_title", comment: "")
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = Color.text.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let labelSubtitle: UILabel = {
        let label = UILabel()
        
        let text = NSLocalizedString("onboarding_subtitle", comment: "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: Color.text.secondary
            ]
        )
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background.primary
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func setupUI() {
        self.view.addSubview(startButton)
        self.view.addSubview(labelTitle)
        self.view.addSubview(labelSubtitle)
        self.view.addSubview(animationView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            startButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            startButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            startButton.heightAnchor.constraint(equalToConstant: 52),
            
            animationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 64),
            animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 220),
            animationView.heightAnchor.constraint(equalToConstant: 220),
            
            labelTitle.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 32),
            labelTitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            labelSubtitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            labelSubtitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func bind() {
        startButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.onClickNext()
            }
            .store(in: &cancellables)
    }
    
    private func sideEffect(effect: SideEffect) {
        switch effect {
        case OnboardingSideEffect.finishOnboarding:
            onFinihed?()
        case OnboardingSideEffect.permissionLocationDenied:
            onPermissionGranted?()
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
}
