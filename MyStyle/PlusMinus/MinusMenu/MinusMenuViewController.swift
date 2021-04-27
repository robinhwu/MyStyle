//
//  MinusMenuViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class MinusMenuViewController: UITableViewController {
    
    @IBOutlet var minusTableView: UITableView!
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        minusTableView.delegate = self
        minusTableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
        snapshot.appendSections([0])
        snapshot.appendItems(menus, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    // MARK: - Table view data source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Int, Menu> {
        
        let cellIdentifier = "Cell"
        
        let dataSource = MinusMenuDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, menu in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MinusMenuTableViewCell
                
                cell.nameLabel.text = menu.name
                
                cell.thumbnailImageView.image = UIImage(named: menu.image)
                
                return cell
            }
        )
        
        return dataSource
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Get the selected movie
        guard let menu = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let minusAction = UIContextualAction(style: .destructive, title: "加") { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([menu])
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        minusAction.backgroundColor = UIColor.systemRed
        minusAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [minusAction])
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
