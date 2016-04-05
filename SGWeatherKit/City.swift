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

    init(name: String, weatherList: [WeatherListItem]) {
        self.name = name
        self.weatherList = weatherList
    }
}

extension City {
    class func parseFromDictionary(dict: Dictionary<String, AnyObject>) -> City {
        var weatherList: [WeatherListItem] = [WeatherListItem]()
        var name: String!

        if let cityName = dict["name"] as? String {
            name = cityName

            // create singular weather list item
            weatherList.append(WeatherListItem.parseFromDictionary(dict))
        } else if let cityDict = dict["city"] as? Dictionary<String, AnyObject> {
            name = cityDict["name"] as? String

            // iterate list items
            if let weatherArray = dict["list"] as? Array<Dictionary<String, AnyObject>> {
                for weatherNode in weatherArray {
                    weatherList.append(WeatherListItem.parseFromDictionary(weatherNode))
                }
            }
        }

        return City(name: name, weatherList: weatherList)
    }
}