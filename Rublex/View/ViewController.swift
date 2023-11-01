//
//  ViewController.swift
//  Rublex
//
//  Created by Macbook on 26.10.2023.
//

import UIKit

class ViewController: UIViewController {

    var searchBar: UISearchBar = {
        let s = UISearchBar()
        return s
    }()
    var cityLabel: UILabel = {
        var l = UILabel()
        l.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return l
    }()
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let keyString = "bd6f8467683e4281ba5172555190902"
        let txtString = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.apixu.com/v1/current.json?key=\(keyString)&q=\(txtString)"
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, err) in
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    as! [String:AnyObject]
            
                if let _ = json["error"] {
                    errorHasOccured = true
                }
            
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
            
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
                }
            
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "n/a"
                        self?.temperatureLabel.isHidden = true
                    } else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(temperature!)"
                        self?.temperatureLabel.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
        
    }

}
