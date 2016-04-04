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
    public var weather: Weather!
    public var wind:           Wind!
    public var environment:    Environment!
    public var sunrise_time:   NSDate!
    public var sunset_time:    NSDate!
    
    init(name: String, weather: Weather, wind: Wind, environment: Environment, sunrise_time: NSDate, sunset_time: NSDate){
        
        self.name         = name
        self.weather      = weather
        self.wind         = wind
        self.environment  = environment
        self.sunrise_time = sunrise_time
        self.sunset_time  = sunset_time
    }
}

extension City {
    class func parseFromDictionary(dict: Dictionary<String,AnyObject>) -> City {
        var weather:Weather!
        var wind:Wind!
        var environment:Environment!
        var sunrise_time:NSDate!
        var sunset_time:NSDate!
        var name: String!
        
        if let cityName = dict["name"] as? String {
            name = cityName
        } else if let cityDict = dict["city"] as? Dictionary<String, AnyObject> {
            name = cityDict["name"] as? String
        }

        // Weather
        if let weatherArray = dict["weather"] as? Array< Dictionary<String, AnyObject> > {
            for weatherNode in weatherArray {
                
                weather = Weather.parseFromDictionary(weatherNode)
                break; // just parse the first one
            }
        }
        
        // Wind
        if let windDict = dict["wind"] as? Dictionary<String, AnyObject> {
            wind = Wind.parseFromDictionary(windDict)
        }
        
        // Environment (main)
        if let environmentDict  = dict["main"] as? Dictionary<String, AnyObject> {
            
            environment = Environment.parseFromDictionary(environmentDict)
        }
        
        // Sys
        if let sysDict = dict["sys"] as? Dictionary<String, AnyObject> {
            var sunriseTimestamp:Double!
            var sunsetStringTimestamp:Double!
            
            if let sunriseTimestamp = sysDict["sunrise"]! as? Double {
                sunrise_time = NSDate(timeIntervalSince1970: sunriseTimestamp)
            }
            if let sunsetTimestamp = sysDict["sunset"]! as? Double {
                sunset_time = NSDate(timeIntervalSince1970: sunsetTimestamp)
            }
        }
        
        return City(name: name, weather: weather, wind: wind, environment: environment, sunrise_time: sunrise_time, sunset_time: sunset_time)
    }
}