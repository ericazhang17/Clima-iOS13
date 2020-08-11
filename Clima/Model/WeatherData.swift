//
//  WeatherData.swift
//  Clima
//
//  Created by Erica Zhang on 8/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

// Used for reading JSON
struct WeatherData : Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Main:Codable {
    let temp:Double
}

struct Weather:Codable {
    let id : Int
}


