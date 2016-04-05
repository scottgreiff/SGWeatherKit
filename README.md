# SGWeatherKit

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*A weather service interface for iOS projects*

## About

This library aims to do the following:

* Provide CLLocation-based an interface to weather information provided by openweathermap.org

For detailed information on the different api calls, check out the official page [here](http://openweathermap.org).

## Requirements

* Xcode 7.3+
* iOS 8.0+
* Swift 2.2+

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "scottgreiff/SGWeatherKit"
````

## Documentation

To get the current weather conditions for a specific location:

```swift
let agent = WeatherKitAgent(apiKey: "your_api_key")
agent.currentWeather(CLLocationCoordinate2D(latitude: 39.961176, longitude: -82.998794)) { result in
  let city: City = result.data()!
	// Do something with the current weather forecast city object here
}
```

To get the weather forecast for a specific location:

```swift
let agent = WeatherKitAgent(apiKey: "your_api_key")
agent.dailyForecast(CLLocationCoordinate2D(latitude: 39.961176, longitude: -82.998794)) { result in
  let city: City = result.data()!
	// Do something with the forecast dictionary here
}
```

## Getting Started

````swift
import SGWeatherKit
````

## Credits

Created and maintained by [**@scottag**](https://twitter.com/scottag).

>**Copyright &copy; 2016-present Scott Greiff.**

*Please provide attribution, it is greatly appreciated.*
