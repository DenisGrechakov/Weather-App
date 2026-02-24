//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit
import Combine

@MainActor
class WeatherViewController: ViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var state: WeatherState? = nil
    private lazy var viewModel: WeatherViewModel = {
        let vm = WeatherViewModelImpl()
        
        vm.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateState(state: state)
            }
            .store(in: &cancellables)
        
        return vm
    }()
    
    private let loaderView: LoaderView = {
        let view = LoaderView()
        return view
    }()
    
    private let retryView: RetryView = {
        let view = RetryView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let headerSectionView = HeaderSectionView()
    private let hourlySectionView = HourlySectionView()
    private let dailySectionView = DailySectionView()
    private let sunSectionView = SunSectionView()
    private let additionalInfoSectionView = AdditionalInfoSectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background.primary
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.onCreate()
        setupUI()
        setupConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onStart()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(headerSectionView)

        contentStackView.addArrangedSubview(additionalInfoSectionView)
        contentStackView.addArrangedSubview(sunSectionView)
        contentStackView.addArrangedSubview(hourlySectionView)
        contentStackView.addArrangedSubview(dailySectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
        ])
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.onStart()
            }
            .store(in: &cancellables)
    }
    
    private func updateState(state: WeatherState) {
        self.state = state

        // --- Retry ---
        if retryView.superview == nil && state.isShowRetry {
            retryView.show(in: self.view)
            retryView.onRetry = { [weak self] in
                self?.viewModel.onRetry()
            }
            
        } else if !state.isShowRetry && retryView.superview != nil {
            retryView.hide()
        }
        
        // --- Loader ---
        if loaderView.superview == nil && state.isLoading {
            loaderView.show(in: self.view)
        } else if !state.isLoading && loaderView.superview != nil {
            loaderView.hide()
        }
        
        // --- Header ---
        headerSectionView.configure(headerInfo: state.headerInfo)

        // --- Additional Info ---
        additionalInfoSectionView.configure(additionalInfo: state.additionalInfo)

        // --- Sun Info ---
        sunSectionView.configure(sunInfo: state.sunInfo)

        // --- Hourly Forecast ---
        hourlySectionView.configure(hourlyForecast: state.hourlyForecast)

        // --- Daily Forecast ---
        dailySectionView.configure(dailyForecast: state.dailyForecast)
    }
}
