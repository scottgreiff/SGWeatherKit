//
//  City.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

public class City {
    public var name: String!
    public var weatherList: [WeatherListItem]?
    public var lat: Double!
    public var lon: Double!

    init(name: String, lat: Double, lon: Double, weatherList: [WeatherListItem]) {
        self.name = name
        self.weatherList = weatherList
    }
}

extension City {
    class func parseFromDictionary(dict: Dictionary<String, AnyObject>) throws -> City {
        var weatherList: [WeatherListItem] = [WeatherListItem]()
        var name: String!
        var lat: Double!
        var lon: Double!

        if let cityName = dict["name"] as? String {
            name = cityName
            
            if let coords = dict["coord"] as? Dictionary<String, AnyObject> {
                lat = coords["lat"] as? Double
                lon = coords["lon"] as? Double
            }

            // create singular weather list item
            
            let listItem = try WeatherListItem.parseFromDictionary(dict)
            weatherList.append(listItem)

        } else if let cityDict = dict["city"] as? Dictionary<String, AnyObject> {
            name = cityDict["name"] as? String

            if let coords = cityDict["coord"] as? Dictionary<String, AnyObject> {
                lat = coords["lat"] as? Double
                lon = coords["lon"] as? Double
            }

            // iterate list items
            if let weatherArray = dict["list"] as? Array<Dictionary<String, AnyObject>> {
                for weatherNode in weatherArray {
                    let listItem = try WeatherListItem.parseFromDictionary(weatherNode)
                    weatherList.append(listItem)
                }
            }
        }
        
        guard let _ = name else { throw ParseError.MissingDictionaryElement }
        guard let _ = lat else { throw ParseError.MissingDictionaryElement }
        guard let _ = lon else { throw ParseError.MissingDictionaryElement }
        guard weatherList.count > 0 else { throw ParseError.MissingDictionaryElement }
        
        return City(name: name, lat: lat, lon: lon, weatherList: weatherList)
    }
}
