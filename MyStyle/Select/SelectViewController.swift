//
//  SelectViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class SelectViewController: UITableViewController {
    
    // MARK: - Properties
    
    let sectionTitle = ["已选", "待选"]
    
    var selectedMenu:[Menu] = []
    var notSelectedMenu = menus
    
    var dataSource: SelectDiffableDataSource!
    var snapshot: NSDiffableDataSourceSnapshot<Int, Menu>!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SelectDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, menu) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectTableViewCell
            cell.nameLabel.text = menu.name
            cell.thumbnailImageView.image = UIImage(named: menu.image)
            return cell
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(menus, toSection: 1)
        
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected movie
        guard var menu = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let plusMinusAction = UIContextualAction(style: .destructive, title: "加") { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([menu])
            if (menu.chosen == true) {
                menu.chosen = false
                snapshot.appendItems([menu], toSection: 1)
            } else {
                menu.chosen = true
                snapshot.appendItems([menu], toSection: 0)
            }
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        if (menu.chosen == true) {
            plusMinusAction.backgroundColor = UIColor.systemRed
            plusMinusAction.image = UIImage(systemName: "trash")
        } else {
            plusMinusAction.backgroundColor = UIColor.systemGreen
            plusMinusAction.image = UIImage(systemName: "heart")
            plusMinusAction.title = "Add"
        }
        
        return UISwipeActionsConfiguration(actions: [plusMinusAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        label.textColor = UIColor.black
        label.font = UIFont(name: "Arial", size: 30)
        label.text = sectionTitle[section]
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

