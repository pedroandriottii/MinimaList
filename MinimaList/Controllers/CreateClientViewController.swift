//
//  CreateClientViewController.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 30/06/24.
//

import UIKit

protocol CreateClientDelegate: AnyObject {
    func didCreateClient()
}

class CreateClientViewController: UIViewController {
    
    let service = Service()
    
    weak var delegate: CreateClientDelegate?
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome do Cliente"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var streetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Rua"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Número"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var neighborhoodTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Bairro"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var complementTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Complemento"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cadastrar Novo Cliente"
        
        view.addSubview(nameTextField)
        view.addSubview(streetTextField)
        view.addSubview(numberTextField)
        view.addSubview(neighborhoodTextField)
        view.addSubview(complementTextField)
        view.addSubview(createButton)
        
        
        createButton.addTarget(self, action: #selector(createClient), for: .touchUpInside)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            streetTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            streetTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            streetTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            numberTextField.topAnchor.constraint(equalTo: streetTextField.bottomAnchor, constant: 20),
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            neighborhoodTextField.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 20),
            neighborhoodTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            neighborhoodTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            complementTextField.topAnchor.constraint(equalTo: neighborhoodTextField.bottomAnchor, constant: 20),
            complementTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            complementTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            createButton.topAnchor.constraint(equalTo: complementTextField.bottomAnchor, constant: 20),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func createClient() {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let street = streetTextField.text, !street.isEmpty,
              let number = numberTextField.text, !number.isEmpty,
              let neighborhood = neighborhoodTextField.text, !neighborhood.isEmpty else {
            return
        }
        
        let client = Client(id: nil, name: name, street: street, number: number, neighborhood: neighborhood, complement: complementTextField.text)
        
        service.create(client: client) { success, error in
            if success {
                self.delegate?.didCreateClient()
                self.navigationController?.popViewController(animated: true)
            } else { return }
        }
    }
}
