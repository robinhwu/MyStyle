//
//  MinusMenuDiffableDataSource.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/22.
//

import UIKit

class MinusMenuDiffableDataSource: UITableViewDiffableDataSource<Int, Menu> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
