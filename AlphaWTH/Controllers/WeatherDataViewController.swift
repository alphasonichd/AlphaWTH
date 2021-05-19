//
//  WeatherDataViewController.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import UIKit

class WeatherDataViewController: UIViewController {
    
    let city: String
    
    init?(coder: NSCoder, city: String) {
        self.city = city
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a city")
    }
    
    private let networkService = NetworkService()
    private var weatherModel: WeatherModel? {
        didSet {
            reloadUI()
        }
    }
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentFeelsLikeTempLabel: UILabel!
    @IBOutlet weak var dataFetchingActivity: UIActivityIndicatorView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeatherImage.isHidden = true
        currentCityLabel.isHidden = true
        currentTempLabel.isHidden = true
        currentFeelsLikeTempLabel.isHidden = true
        
        setupCollectionView()

        title = "Weather for \(city)"

        loadWeatherForecast()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
        currentCityLabel.font = UIFont(name: currentCityLabel.font.fontName, size: 20.0)
        currentTempLabel.font = UIFont(name: currentCityLabel.font.fontName, size: 15.0)
        currentFeelsLikeTempLabel.font = UIFont(name: currentCityLabel.font.fontName, size: 15.0)
    
        }
    
    private func loadWeatherForecast() {
        networkService.getWeather(for: city) { [weak self] weatherModel, error in
            guard let weatherModel = weatherModel, error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async {
                self?.weatherModel = weatherModel
                self?.hideFetching()
            }
        }
    }
    
    private func reloadUI() {
        guard let weatherModel = weatherModel else { return }
        currentCityLabel.text = city
        currentTempLabel.text = "\(weatherModel.temperatureString)°C"
        currentFeelsLikeTempLabel.text = "Feels like: \(weatherModel.feelsLikeString)"
        currentWeatherImage.image = UIImage(systemName: WeatherModel.systemIconName(for: weatherModel.conditionId))
        dailyCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        dailyCollectionView.dataSource = self
        dailyCollectionView.register(UINib(nibName: "DailyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.dailyCell)
        dailyCollectionView.reloadData()
    }
    
    private func hideFetching() {
        dataFetchingActivity.isHidden = true
        currentWeatherImage.isHidden = false
        currentCityLabel.isHidden = false
        currentTempLabel.isHidden = false
        currentFeelsLikeTempLabel.isHidden = false
    }
}

extension WeatherDataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel?.dailyData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dailyCollectionView.dequeueReusableCell(withReuseIdentifier: K.dailyCell, for: indexPath) as? DailyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let weatherModel = weatherModel else { return cell }
        
        let dayData = weatherModel.dailyData[indexPath.item]
        
        cell.dateLabel.text = String(dayData.dt)
        cell.iconImageView.image = UIImage(systemName: WeatherModel.systemIconName(for: dayData.weather[0].id))
        cell.tempLabel.text = "\(String(format: "%.1f", dayData.temp.day))°C"
        cell.descriptionLabel.text = dayData.weather[0].description
        
        return cell
    }
    
}

