//
//  CustomTableViewCell.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier: String = "CustomTableViewCell"
    
    private var customView: CustomView = {
        let view = CustomView()
    }
}
