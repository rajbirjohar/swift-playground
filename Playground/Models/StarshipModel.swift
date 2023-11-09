//
//  StarshipModel.swift
//  Playground
//
//  Created by Rajbir Johar on 11/8/23.
//

import Foundation

struct Starship: Identifiable, Codable {
    let url: String
    
    var id: String { url }
    let name: String
    let model: String
    let starship_class: String
    let manufacturer: String
    let cost_in_credits: String
    let crew: String
    let passengers: String
    let max_atmosphering_speed: String
    let hyperdrive_rating: String
    let MGLT: String
    let cargo_capacity: String
    let consumables: String?
    
    // Implement the Equatable protocol if needed
    static func == (lhs: Starship, rhs: Starship) -> Bool {
        return lhs.id == rhs.id // Assuming 'id' is the unique identifier
    }
}

struct StarshipResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Starship]
}
