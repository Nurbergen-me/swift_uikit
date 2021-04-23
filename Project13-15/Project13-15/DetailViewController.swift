//
//  DetailViewController.swift
//  Project13-15
//
//  Created by Nurbergen Yeleshov on 12.01.2021.
//

import UIKit

class DetailViewController: UITableViewController {
    var details: Country!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Country")
        
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
    
        cell.textLabel?.text = details.name
        return cell
    }
}
