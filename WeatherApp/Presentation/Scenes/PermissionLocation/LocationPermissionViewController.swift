//
//  LocationPermissionViewController.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit
import Combine

@MainActor
class LocationPermissionViewController: ViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    var onFinihed: (() -> Void)?
    
    private lazy var viewModel: LocationPermissionViewModel = {
        let vm = LocationPermissionViewModelImpl()
        
        vm.effects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] effect in
                self?.sideEffect(effect: effect)
            }
            .store(in: &cancellables)
        
        return vm
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_logo_perm_location"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("location_permission_title", comment: "")
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = Color.text.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let labelSubtitle: UILabel = {
        let label = UILabel()
        
        let text = NSLocalizedString("location_permission_subtitle", comment: "")
        
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let containerForButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let allowButton: FillButton = {
        let button = FillButton()
        button.setTitle(NSLocalizedString("location_permission_allow_button", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let laterButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("location_permission_later_button", comment: ""), for: .normal)
        button.setTitleColor(Color.text.secondary, for: .normal)
        button.backgroundColor = Color.clear
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background.primary
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func setupUI() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(labelTitle)
        self.view.addSubview(labelSubtitle)
        self.view.addSubview(containerForButtons)
        
        containerForButtons.addArrangedSubview(allowButton)
        containerForButtons.addArrangedSubview(laterButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            labelTitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            labelSubtitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            labelSubtitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            containerForButtons.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -32) ,
            containerForButtons.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerForButtons.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            allowButton.heightAnchor.constraint(equalToConstant: 52),
            laterButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func bind() {
        allowButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.onClickAllow()
            }
            .store(in: &cancellables)
        
        laterButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.onClickLater()
            }
            .store(in: &cancellables)
    }
    
    private func sideEffect(effect: SideEffect) {
        switch effect {
            
        case LocationPermissionSideEffect.finish:
            onFinihed?()
        
        default:
            break
        }
    }
}
