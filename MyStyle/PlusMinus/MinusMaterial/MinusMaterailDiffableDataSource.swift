//
//  MinusMaterailDiffableDataSource.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/22.
//

import UIKit


class MinusMaterailDiffableDataSource: UITableViewDiffableDataSource<Int, Material> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let materail = self.itemIdentifier(for: indexPath) {
//                var snapshot = self.snapshot()
//                snapshot.deleteItems([materail])
//                self.apply(snapshot, animatingDifferences: true)
//            }
//        }
//    }
    
}
