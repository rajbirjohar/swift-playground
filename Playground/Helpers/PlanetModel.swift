//
//  PlanetModel.swift
//  Playground
//
//  Created by Rajbir Johar on 11/8/23.
//

import Foundation

// Define the model for the planet
struct Planet: Identifiable, Codable {
    let url: String

    // Here we use the URL string as the unique identifier
    var id: String { url }
    let name: String
    let diameter: String
    let climate: String
    let gravity: String
    let population: String
    let terrain: String
    
    // Implement the Equatable protocol if needed
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.id == rhs.id // Assuming 'id' is the unique identifier
    }
}

// Define the response model
struct PlanetsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Planet]
}
