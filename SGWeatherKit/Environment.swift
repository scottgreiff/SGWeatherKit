//
//  Environment.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

/**
 An Environment object contains the temperature, humidity and air pressure details 
    for a single Weather forecast item.
 */
public class Environment {
    
    // MARK: Properties
    
    public var humidity: Double!
    public var pressure: Double!
    public var temp: Double!
    public var temp_max: Double!
    public var temp_min: Double!

    // MARK: Methods

    init(humidity: Double, pressure: Double, temp: Double, temp_max: Double, temp_min: Double) {
        self.humidity = humidity
        self.pressure = pressure
        self.temp = temp
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
}

extension Environment {
    internal class func parseFromDictionary(dict: [String:AnyObject]) -> Environment {
        let humidity = dict["humidity"]! as! Double
        let pressure = dict["pressure"]! as! Double
        let temp = dict["temp"]! as! Double
        let temp_max = dict["temp_max"]! as! Double
        let temp_min = dict["temp_min"]! as! Double

        return Environment(humidity: humidity, pressure: pressure, temp: temp, temp_max: temp_max, temp_min: temp_min)
    }

    internal class func parseFromListDictionary(dict: [String:AnyObject], humidity: Double, pressure: Double) -> Environment {
        let temp = dict["day"]! as! Double
        let temp_max = dict["max"]! as! Double
        let temp_min = dict["min"]! as! Double

        return Environment(humidity: humidity, pressure: pressure, temp: temp, temp_max: temp_max, temp_min: temp_min)
    }
}