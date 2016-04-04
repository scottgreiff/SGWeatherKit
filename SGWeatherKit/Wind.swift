//
//  Wind.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

public class Wind {
    var speed:Double!
    var deg:Double!
    
    init(speed:Double, deg:Double){
        self.speed = speed;
        self.deg   = deg;
    }
}

extension Wind {
    class func parseFromDictionary(dict: [String: AnyObject]) -> Wind {
        let speed = dict["speed"]! as! Double
        let deg   = dict["deg"]! as! Double
        
        return Wind(speed: speed, deg: deg)
    }
}