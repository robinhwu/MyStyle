//
//  SelectViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import CoreData

class SelectViewController: UITableViewController {
    
    // MARK: - Properties
    
    var menuItems: [Menu] = []
    var menus: [Menu] = []
    var fetchResultController: NSFetchedResultsController<Menu>!
    
    let sectionTitle = [NSLocalizedString("已选", comment: "已选"), NSLocalizedString("待选", comment: "待选")]
    
    var selectedMenu:[Menu] = []
    var notSelectedMenu: [Menu] = []
    
    var dataSource: SelectDiffableDataSource!
    var snapshot: NSDiffableDataSourceSnapshot<Int, Menu>!
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle(NSLocalizedString("确定", comment: "确定"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    // MARK: - Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SelectDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, menu) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectTableViewCell
            cell.nameLabel.text = menu.name
            
            if menu.isPreload {
                cell.thumbnailImageView.image = UIImage(named: menu.imageName!)
            } else {
                let url = self.documentDirectoryPath()?.appendingPathComponent(menu.imageName!)
                let pngImage = UIImage(contentsOfFile: url!.path)
                cell.thumbnailImageView.image = pngImage
            }
            
            return cell
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
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
            do {
                notSelectedMenu = try context.fetch(fetchRequest)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(selectedMenu, toSection: 0)
        snapshot.appendItems(notSelectedMenu, toSection: 1)
        
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load material items from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let fetchMenusRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchMenusRequest.sortDescriptors = [nameSortDescriptor]
            fetchMenusRequest.predicate = NSPredicate(format: "chosen == %@", NSNumber(value: true))
            let context = appDelegate.persistentContainer.viewContext
            do {
                menuItems = try context.fetch(fetchMenusRequest)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
            for menu in menuItems {
                menu.chosen = false
            }
            appDelegate.saveContext()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            for menu in selectedMenu {
                menu.chosen = false
            }
            appDelegate.saveContext()
        }
    }
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            faButton.heightAnchor.constraint(equalToConstant: 80),
            faButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        faButton.layer.cornerRadius = 40
        faButton.layer.masksToBounds = true
        faButton.layer.borderColor = UIColor.lightGray.cgColor
        faButton.layer.borderWidth = 4
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected movie
        guard let menu = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let plusMinusAction = UIContextualAction(style: .destructive, title: "加") { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([menu])
            if (menu.chosen == true) {
                menu.chosen = false
                snapshot.appendItems([menu], toSection: 1)
                self.notSelectedMenu.append(menu)
                self.selectedMenu = self.selectedMenu.filter{
                    $0.name != menu.name
                }
            } else {
                menu.chosen = true
                snapshot.appendItems([menu], toSection: 0)
                self.selectedMenu.append(menu)
                self.notSelectedMenu = self.notSelectedMenu.filter{
                    $0.name != menu.name
                }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
        performSegue(withIdentifier: "toSelected", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SelectedViewController
        
        controller.menusList = getMenusList()
        controller.materialsList = getMaterialsList()
    }
    
    func getMenusList() -> [Menu] {
        var menusList: [Menu] = []
        
        for menu in selectedMenu {
            menusList.append(menu)
        }
        
        return menusList
    }
    
    func getMaterialsList() -> [String] {
        var materialsList: [String] = []
        var materailDict: [Material: Int] = [:]
        
        for menu in selectedMenu {
  
            for materail in menu.materials as! Set<Material>{
                if materailDict[materail] != nil {
                    materailDict[materail]! += 1
                } else {
                    materailDict[materail] = 1
                }
            }
        }
        
        for (material, quantity) in materailDict {
            materialsList.append(material.name! + " x " + String(quantity))
        }
        
        return materialsList
    }
}

