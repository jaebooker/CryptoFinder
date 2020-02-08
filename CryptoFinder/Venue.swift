//
//  Venue.swift
//  CryptoFinder
//
//  Created by Jaeson Booker on 2/1/20.
//  Copyright © 2020 Jaeson Booker. All rights reserved.
//

import Foundation

struct VenueList: Decodable {
    let venues: [Venue]
}

//venue features matching API

struct Venue: Decodable {
    
    let created_on: Int
    let id: Int
    let name: String
    let category: String?
    let lat: Float
    let lon: Float
    
    let lat2: Float?
    let lon1: Float?
    let lon2: Float?
    let query: String?
    let owner: String?
    let upvoter: String?
    let before: Date?
    let after: Date?
    let offset: Int?
    let mode: String?
    
}
