//
//  ViewController.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var clients: [Client] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(table)
        setConstraints()
        
        fetchData()
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData() {
        let service = Service()
        service.get() { result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    print("Error: \(error)")
                case let .success(clients):
                    self.clients = clients
                    self.table.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        let client = clients[indexPath.row]
        cell.textLabel?.text = client.name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clientes"
    }
}
