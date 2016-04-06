//
//  SGWeatherKitTests.swift
//  SGWeatherKitTests
//
//  Created by Scott Alan Greiff on 4/4/16.
//  Copyright © 2016 Scott Alan Greiff. All rights reserved.
//

import CoreLocation
import XCTest

@testable import SGWeatherKit

class SGWeatherKitTests: XCTestCase {
    
    var agent: WeatherKitAgent!
    
    override func setUp() {
        super.setUp()
        
        self.agent = WeatherKitAgent(apiKey: "195ca018929c41a89f286e0910a5da77")
    }
    
    override func tearDown() {
        self.agent = nil
        
        super.tearDown()
    }
    
    func testAgentReturned() {
        XCTAssertNotNil(self.agent)
    }
    
    func testInit() {
        XCTAssertEqual(agent.apiKey, "195ca018929c41a89f286e0910a5da77")
        XCTAssertEqual(agent.apiVersion, "2.5")
    }
    
    func testGetWeatherForLatLon() {
        XCTAssertNotNil(self.agent)
        
        let expectation = expectationWithDescription("currentWeatherByCoordinate")

        agent.currentWeather(CLLocationCoordinate2D(latitude: 39.961176, longitude: -82.998794)) { result in
            let url = result.response()?.URL!.absoluteString
            let city: City = result.data()!
            XCTAssertNotNil(url)
            XCTAssertNotNil(city)
            XCTAssertNotNil(city.lat)
            XCTAssertNotNil(city.lon)
            XCTAssertEqual("http://api.openweathermap.org/data/2.5/weather?lat=39.961176&lon=-82.998794&APPID=195ca018929c41a89f286e0910a5da77&units=imperial", url!)
            XCTAssertNotNil(city.name as String)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testBadLocationShouldReturnError() {
        XCTAssertNotNil(self.agent)
        
        let expectation = expectationWithDescription("currentWeatherByCoordinate")
        
        agent.currentWeather(CLLocationCoordinate2D(latitude: -100000, longitude: -10000)) { result in
            let error = result.error()
            XCTAssertNotNil(error)
            XCTAssertNil(result.data())
            XCTAssert(error!.domain == "SGWeatherKit.WeatherKitAgent.ParseError")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testForEmptyResult() {
        let badData = Dictionary<String, AnyObject>() //  ["name": "SomePlace"]
        
        do {
            let newCity = try City.parseFromDictionary(badData)
            XCTAssertNil(newCity)
        } catch WeatherKitAgent.ParseError.MissingDictionaryElement {
            XCTAssert(true)
        } catch {
            XCTAssert(false, "Expecting a specific ParseError.MissingDictionaryElement type of error")
        }
    }
    
    func testForEmptyWeatherInfoResult() {
        let badData = ["name": "SomePlace"]
        
        do {
            let newCity = try City.parseFromDictionary(badData)
            XCTAssertNil(newCity)
        } catch WeatherKitAgent.ParseError.MissingDictionaryElement {
            XCTAssert(true)
        } catch {
            XCTAssert(false, "Expecting a specific ParseError.MissingDictionaryElement type of error")
        }
    }
    
    func testGetForecastForLatLon() {
        XCTAssertNotNil(self.agent)
        
        let expectation = expectationWithDescription("dailyForecastByCoordinate")

        agent.dailyForecast(CLLocationCoordinate2D(latitude: 39.961176, longitude: -82.998794)) { result in
            let url = result.response()?.URL!.absoluteString
            let city: City = result.data()!
            XCTAssertNotNil(url)
            XCTAssertNotNil(city)
            XCTAssertEqual("http://api.openweathermap.org/data/2.5/forecast/daily?lat=39.961176&lon=-82.998794&APPID=195ca018929c41a89f286e0910a5da77&units=imperial", url!)
            XCTAssertNotNil(city.name as String)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
