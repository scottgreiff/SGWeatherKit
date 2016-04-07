//
//  WeatherListItem.swift
//  SGWeatherKit
//
//  Created by Scott Alan Greiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

/**
 A Weather List Item object is the wrapper for a single set of conditions
 */
public class WeatherListItem {

    // MARK: Properties
    
    public var weather: Weather!
    public var environment: Environment!
    public var wind: Wind!
    public var sunrise_time: NSDate?
    public var sunset_time: NSDate?
    public var forecastDate: NSDate!

    // MARK: Methods

    init(weather: Weather, environment: Environment, wind: Wind, sunriseTime: NSDate?, sunsetTime: NSDate?, forecastDate: NSDate) {
        self.weather = weather
        self.environment = environment
        self.wind = wind
        self.sunrise_time = sunriseTime
        self.sunset_time = sunsetTime
        self.forecastDate = forecastDate
    }
}

extension WeatherListItem {
    internal class func parseFromDictionary(dict: Dictionary<String, AnyObject>) throws -> WeatherListItem {
        var weather: Weather!
        var wind: Wind!
        var environment: Environment!
        var sunrise_time: NSDate?
        var sunset_time: NSDate?
        var forecastDate: NSDate!

        // Weather
        if let weatherArray = dict["weather"] as? Array<Dictionary<String, AnyObject>> {
            for weatherNode in weatherArray {
                weather = Weather.parseFromDictionary(weatherNode)
                break; // just parse the first one
            }
        }

        // Wind
        if let windDict = dict["wind"] as? Dictionary<String, AnyObject> {
            wind = Wind.parseFromDictionary(windDict)
        } else if let speed = dict["speed"] as? Double {
            if let degree = dict["deg"] as? Double {
                wind = Wind.parseFromDictionary(["speed": speed, "deg": degree])
            }
        }

        // Environment (main)
        if let environmentDict = dict["main"] as? Dictionary<String, AnyObject> {
            environment = Environment.parseFromDictionary(environmentDict)
        } else if let environmentDict = dict["temp"] as? Dictionary<String, AnyObject> {
            environment = Environment.parseFromListDictionary(environmentDict, humidity: (dict["humidity"] as? Double)!, pressure: (dict["pressure"] as? Double)!)
        }

        // Sys
        if let sysDict = dict["sys"] as? Dictionary<String, AnyObject> {
            if let sunriseTimestamp = sysDict["sunrise"] as? Double {
                sunrise_time = NSDate(timeIntervalSince1970: sunriseTimestamp)
            }

            if let sunsetTimestamp = sysDict["sunset"] as? Double {
                sunset_time = NSDate(timeIntervalSince1970: sunsetTimestamp)
            }
        }

        if let fDate = dict["dt"] as? Double {
            forecastDate = NSDate(timeIntervalSince1970: fDate)
        }

        guard let _ = weather else { throw WeatherKitAgent.ParseError.MissingDictionaryElement }
        guard let _ = wind else { throw WeatherKitAgent.ParseError.MissingDictionaryElement }
        guard let _ = environment else { throw WeatherKitAgent.ParseError.MissingDictionaryElement }
        guard let _ = forecastDate else { throw WeatherKitAgent.ParseError.MissingDictionaryElement }

        return WeatherListItem(weather: weather, environment: environment, wind: wind, sunriseTime: sunrise_time, sunsetTime: sunset_time, forecastDate: forecastDate)
    }
}