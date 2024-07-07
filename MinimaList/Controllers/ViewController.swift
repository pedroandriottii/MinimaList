//
//  ViewController.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    let service = Service()
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var addBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var clients: [Client] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(table)
        view.addSubview(addBtn)
        setConstraints()
        
        addBtn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        fetchData()
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addBtn.widthAnchor.constraint(equalToConstant: 50),
            addBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Carregando clientes da API
    func fetchData() {
        service.getAllClients { result, error in
            if let client = result {
                DispatchQueue.main.async {
                    self.clients = client
                    self.table.reloadData()
                }
            } else { return }
        }
    }
    
    @objc func addButtonTapped(){
        let createClientVC = CreateClientViewController()
        createClientVC.delegate = self
        navigationController?.pushViewController(createClientVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    // Numero de Secoes
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Tamanho da Tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    // Definindo dado das Celulas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        let client = clients[indexPath.row]
        cell.textLabel?.text = client.name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let client = clients[indexPath.row]
        let detailVC = ClientDetailsViewController()
        detailVC.client = client
        navigationController?.pushViewController(detailVC, animated: true)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clientes"
    }
}

// Atualizando a table apos criar o cliente
extension ViewController: CreateClientDelegate {
    func didCreateClient() {
        fetchData()
        table.reloadData()
    }
}
