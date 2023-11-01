//
//  RecordsViewController.swift
//  Rublex
//
//  Created by Macbook on 26.10.2023.
//

import UIKit

class RecordsViewController: UIViewController  {
    var arrayKeyProfile: [String] = ["gjkg"]
    private lazy var recordsTable: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        
        
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recordsTable)
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayKeyProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recordsTable.dequeueReusableCell(withIdentifier: RecordsTableViewCell.identifier, for: indexPath) as? RecordsTableViewCell else { return UITableViewCell() }
        cell.configure(with: arrayKeyProfile[indexPath.row])
        return cell
    }
}
