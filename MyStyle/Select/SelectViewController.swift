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
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("确定", for: .normal)
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
            cell.thumbnailImageView.image = UIImage(named: menu.imagePath)
            return cell
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(notSelectedMenu, toSection: 1)
        
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
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
  
            for materail in menu.meterials {
                if materailDict[materail] != nil {
                    materailDict[materail]! += 1
                } else {
                    materailDict[materail] = 1
                }
            }
        }
        
        for (material, quantity) in materailDict {
            materialsList.append(material.name + " x " + String(quantity))
        }
        
        return materialsList
    }
}

