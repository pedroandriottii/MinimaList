//
//  ClientDetailsViewController.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 01/07/24.
//

import UIKit


class ClientDetailsViewController: UIViewController {
    
    var client: Client!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = client.name
    }
    
}
