//
//  ViewController.swift
//  Weather
//
//  Created by Hassan Almasri on 26/12/2015.
//  Copyright © 2015 Hassan Almasri. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var shouldUpdateDataForLocation = true
    
    @IBAction func stanbbut(sender: AnyObject) {
        
        self.shouldUpdateDataForLocation = true
    }

    deinit {
        WeatherLocationManager.sharedInstance.unsubscribeNewLocation(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationField.delegate = self
        
        
        WeatherLocationManager.sharedInstance.subscribeNewLocation(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func getWeatherData(urlString: String) {
        
        let url = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if error != nil {
                debugPrint(error)
            }
            else {
                dispatch_async(dispatch_get_main_queue(),{
                   self.setLabels(data!)
                })
            }
            
        }
        task.resume()
    }
    
    func setLabels(weatherData : NSData) {
        
        
        do{
        
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .MutableLeaves) as! [String: AnyObject]
        
            if let name = json["name"] as? String {
                cityLabel.text = name
            }
            if let main = json["main"] as? [String: AnyObject] {
                if let temperature = main["temp"] as? Double {
                    temperatureLabel.text = String(format: "%.1f",  temperature)
                }
            }
            if let weathers = json["weather"] as? [[String: AnyObject]] {
                for weather in weathers {
                    if let condition = weather["main"] as? String {
                        conditionLabel.text = condition
                    }
                }
            }
        
        
        }
        catch let error as NSError {
        
            debugPrint("\(error.description)")
            
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(locationField.text!)&units=metric&APPID=f315b6694eeb7d1d58af95892884b5ea")
        
        textField.resignFirstResponder()
        performAction()
        return true
    }
    
    func performAction() {
        
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(locationField.text!)&units=metric&APPID=f315b6694eeb7d1d58af95892884b5ea")
        
    }
    
}

extension ViewController: LocationUpdateObserver {
    func newLocationAvailable(location: CLLocation) {
        
        if self.shouldUpdateDataForLocation {
            
            self.getWeatherData("http://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&APPID=f315b6694eeb7d1d58af95892884b5ea")
            self.shouldUpdateDataForLocation = false
        }
    }
}

