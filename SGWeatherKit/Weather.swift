//
//  Weather.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation

/**
 A Weather item has the conditions, description and OpenWeatherMap.org icon name
 */
public class Weather {
    
    // MARK: Properties
    
    public var id: Int!
    public var main: String!
    public var description: String!
    public var icon: String!

    // MARK: Methods

    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}

extension Weather {
    internal class func parseFromDictionary(dict: Dictionary<String, AnyObject>) -> Weather {
        let id = dict["id"]! as! Int
        let main = dict["main"]! as! String
        let description = dict["description"]! as! String
        let icon = dict["icon"]! as! String

        return Weather(id: id, main: main, description: description, icon: icon)
    }
}