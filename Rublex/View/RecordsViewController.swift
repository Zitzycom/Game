//
//  RecordsViewController.swift
//  Rublex
//
//  Created by Macbook on 26.10.2023.
//

import UIKit

final class RecordsViewController: UIViewController  {
    
    // MARK: -  Private properties
    
    private var gameManager = GameManager()
    private var record: [Player] = []
    
    private lazy var recordsTable: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        record = gameManager.keyPlayer.compactMap { (UserDefaults.standard.value(Player.self, forKey: $0)) }
        record.sort(by: {$0.score > $1.score})
        view.addSubview(recordsTable)
    }
}

//MARK: - Delegate

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recordsTable.dequeueReusableCell(withIdentifier: RecordsTableViewCell.identifier, for: indexPath) as? RecordsTableViewCell else { return UITableViewCell() }
        let user = record[indexPath.row]
        cell.configure(player: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           LocalConstants.heightForRowAt
       }
}
//MARK: - private constants
private enum LocalConstants {
    static var heightForRowAt: CGFloat {80}
}
