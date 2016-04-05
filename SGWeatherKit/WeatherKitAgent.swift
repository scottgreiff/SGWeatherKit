//
//  WeatherKitAgent.swift
//  SGWeatherKit
//
//  Created by sgreiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import Foundation
import CoreLocation

/**
 An instance of the `WeatherKitAgnet` serves as the worker to process all calls to the openweathermap.org weather servcie.
 
 The agent needs to be initialized with an API key that can be obtained from openweathermap.org.
 */

public final class WeatherKitAgent {

    // MARK: Properties 

    /// The API key used to make weather service calls
    public let apiKey: String

    public var apiVersion: String {
        return Const.apiVersion
    }

    static let basePath = "http://api.openweathermap.org/data/"

    public enum Result {
        case Success(NSURLResponse!, City!)
        case Error(NSURLResponse!, NSError!)

        public func data() -> City? {
            switch self {
            case .Success(_, let city):
                return city
            case .Error(_, _):
                return nil
            }
        }

        public func response() -> NSURLResponse? {
            switch self {
            case .Success(let response, _):
                return response
            case .Error(let response, _):
                return response
            }
        }

        public func error() -> NSError? {
            switch self {
            case .Success(_, _):
                return nil
            case .Error(_, let error):
                return error
            }
        }
    }

    private struct Const {
        static let basePath = "http://api.openweathermap.org/data/"
        static let apiVersion = "2.5"
    }

    // MARK: Initialization

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: Get current weather data

    /**
     Gets the current weather conditions given the location in the form of CLLocationCoordiate2D
     
     :param: coordinate CLLocationCoordinate2D
     */
    public func currentWeather(coordinate: CLLocationCoordinate2D, callback: (Result) -> ()) {
        let coordinateString = "lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        call("/weather?\(coordinateString)", callback: callback)
    }

    // MARK: Get daily forecast

    /**
     Gets the weather forecast given the location in the form of CLLocationCoordiate2D
     
     :param: coordinate CLLocationCoordinate2D
     */
    public func dailyForecast(coordinate: CLLocationCoordinate2D, callback: (Result) -> ()) {
        call("/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)", callback: callback)
    }

    // MARK: Call openweather.org API

    private func call(method: String, callback: (Result) -> ()) {
        let url = Const.basePath + Const.apiVersion + method + "&APPID=\(apiKey)&units=imperial"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let currentQueue = NSOperationQueue.currentQueue()

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var error: NSError? = error
            let dictionary: NSDictionary?
            var city: City?

            if let data = data {
                do {
                    dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    city = City.parseFromDictionary(dictionary as! Dictionary<String, AnyObject>)
                } catch let e as NSError {
                    error = e
                } catch {
                }
            }

            currentQueue?.addOperationWithBlock {
                var result = Result.Success(response, city)
                if error != nil {
                    result = Result.Error(response, error)
                }
                callback(result)
            }
        }
        task.resume()
    }
}