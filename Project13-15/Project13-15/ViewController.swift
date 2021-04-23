//
//  ViewController.swift
//  Project13-15
//
//  Created by Nurbergen Yeleshov on 12.01.2021.
//

import UIKit

class ViewController: UITableViewController {
    var countriesList = [Country]() 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let dataURL = URL(string: "https://restcountries.eu/rest/v2/all") {
            if let data = try? Data(contentsOf: dataURL) {
                let jsonDecoder = JSONDecoder()
                
                if let jsonData = try? jsonDecoder.decode([Country].self, from: data) {
                    countriesList = jsonData
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = countriesList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.details = countriesList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
