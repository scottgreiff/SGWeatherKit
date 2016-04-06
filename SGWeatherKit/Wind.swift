//
//  Wind.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

/**
 A Wind item has specific detail about winds for a Weather condition item.
 */
public class Wind {
    
    // MARK: Properties
    
    public var speed: Double!
    public var deg: Double!

    // MARK: Methods

    init(speed: Double, deg: Double) {
        self.speed = speed;
        self.deg = deg;
    }
}

extension Wind {
    internal class func parseFromDictionary(dict: [String:AnyObject]) -> Wind {
        let speed = dict["speed"]! as! Double
        let deg = dict["deg"]! as! Double

        return Wind(speed: speed, deg: deg)
    }
}