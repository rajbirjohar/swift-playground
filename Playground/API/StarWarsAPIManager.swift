//
//  StarWarsAPIManager.swift
//  Playground
//
//  Created by Rajbir Johar on 11/8/23.
//

import Foundation

class StarWarsAPIManager {
    static let shared = StarWarsAPIManager()
    
    let baseUrl = "https://swapi.dev/api"
    
    func fetchPlanets(page: Int) async throws -> [Planet] {
        let urlString = baseUrl + "/planets/?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let planetsResponse = try decoder.decode(PlanetsResponse.self, from: data)
        
        return planetsResponse.results
    }
    
    func fetchStarships(page: Int) async throws -> [Starship] {
        let urlString = baseUrl + "/starships/?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let starshipResponse = try decoder.decode(StarshipResponse.self, from: data)
        
        return starshipResponse.results
    }
}
