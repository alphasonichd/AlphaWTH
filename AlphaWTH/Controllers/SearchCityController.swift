//
//  ViewController.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import UIKit

class SearchCityController: UIViewController {
    
    private let searchData = SearchService()
    private var matchedCities: [String] = [] {
        didSet {
            cityTableView.reloadData()
        }
    }
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var appLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        citySearchBar.delegate = self
        appLabel.text = ""
        var count = 0.0
        for letter in "❄️AlphaWTH" {
            Timer.scheduledTimer(withTimeInterval: 0.1 * count, repeats: false) { (timer) in
                self.appLabel.text?.append(letter)
            }
            count += 1
        }
        setupTableView()
        setupSeachBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupTableView() {
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: K.searchCell)
    }
    
    func setupSeachBar() {
        citySearchBar.barTintColor = .clear
        citySearchBar.backgroundColor = .clear
        citySearchBar.isTranslucent = true
        citySearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
}

extension SearchCityController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchedCities = searchData.getMatchedCities(for: searchText)
    }
}

extension SearchCityController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cityTableView.dequeueReusableCell(withIdentifier: K.searchCell) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.cityLabel.text = matchedCities[indexPath.row]
        return cell
    }
}

extension SearchCityController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = matchedCities[indexPath.row]
        let weatherDataViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WeatherDataViewController") { coder in
            return WeatherDataViewController(coder: coder, city: city)
        }
        navigationController?.pushViewController(weatherDataViewController, animated: true)
    }
}

