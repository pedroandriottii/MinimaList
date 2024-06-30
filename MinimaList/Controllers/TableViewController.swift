//
//  TableViewController.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit


private var table: UITableView = {
    let table = UITableView()
    return table
}()

class TableViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
    }



}
