//
//  SearchData.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import Foundation

final class SearchService {
    
    private static let cities = ["Minsk", "Moscow", "Warsaw", "Tokyo", "Kyoto", "Kyiv", "London", "Lviv", "Gomel", "Vitebsk", "Brest",
    "Madrid", "Paris", "Seoul"]
    
    func getMatchedCities(for input: String) -> [String] {
        return SearchService.cities.filter {$0.contains(input)}
    }
}
