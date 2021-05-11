//
//  MinusMaterialViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class MinusMaterialViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet var minusMaterialTableView: UITableView!
    
    lazy var dataSource = configureDataSource()
    
    var deleteMaterials = materials.filter{
        $0.count == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        minusMaterialTableView.delegate = self
        minusMaterialTableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Material>()
        snapshot.appendSections([0])
        snapshot.appendItems(deleteMaterials, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }

    // MARK: - Table view data source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Int, Material> {
        
        let cellIdentifier = "Cell"
        
        let dataSource = MinusMaterailDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, material in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MinusMaterialTableViewCell
                
                cell.nameLabel.text = material.name

                cell.thumbnailImageView.backgroundColor = UIColor.randomColor()
                
                return cell
            }
        )
        
        return dataSource
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Get the selected movie
        guard let material = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let minusAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([material])
            materials = materials.filter{
                $0.name != material.name
            }
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
