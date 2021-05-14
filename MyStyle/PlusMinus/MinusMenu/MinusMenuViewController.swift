//
//  MinusMenuViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import CoreData

class MinusMenuViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var minusTableView: UITableView!
    
    lazy var dataSource = configureDataSource()
    
    private var menuItems:[Menu] = []
    var fetchResultController: NSFetchedResultsController<Menu>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        minusTableView.delegate = self
        minusTableView.dataSource = dataSource
        
        // Load menu items from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            fetchResultController.delegate = self
            do {
                menuItems = try context.fetch(fetchRequest)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
        snapshot.appendSections([0])
        snapshot.appendItems(menuItems, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    // MARK: - Table view data source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Int, Menu> {
        
        let cellIdentifier = "Cell"
        
        let dataSource = MinusMenuDiffableDataSource(
            tableView: tableView,
            cellProvider: { [self]  tableView, indexPath, menu in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MinusMenuTableViewCell
                
                cell.nameLabel.text = menu.name
                
                if menu.isPreload {
                    cell.thumbnailImageView.image = UIImage(named: menu.imageName!)
                } else {
                    let url = documentDirectoryPath()?.appendingPathComponent(menu.imageName!)
                    print(url!.path)
                    let pngImage = UIImage(contentsOfFile: url!.path)
                    cell.thumbnailImageView.image = pngImage
                }
                return cell
            }
        )
        
        return dataSource
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Get the selected menu
        guard let menu = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let minusAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([menu])
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let menuToDelete = menu
                
                print(menuToDelete.name!)
                
                for material in menuToDelete.materials as! Set<Material> {
                    print("minus \(material.name!) count")
                    material.count -= 1
                    material.removeFromMenus(menuToDelete)
                    appDelegate.saveContext()
                }
                
                context.delete(menuToDelete)
                
                appDelegate.saveContext()
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
    
    
    func findIndex(material selectedMaterial: Material, list materialsList: [Material])-> Int {
        for i in 0...materialsList.count-1 {
            if (materialsList[i].name == selectedMaterial.name) {
                return i
            }
        }
        return -1
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
