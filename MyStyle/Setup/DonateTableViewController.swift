//
//  DonateTableViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/5/27.
//

import UIKit

class DonateTableViewController: UITableViewController {
    let nameList = ["🍌  投喂一份香蕉", "🍍  投喂一份菠萝", "🍉  投喂一份西瓜"]
    let priceList = ["¥6.00", "¥12.00", "¥30.00"]
    let donateNote = "如果你喜欢这个应用，你可以给野生程序猿阿黄投喂一些水果，帮助他快速恢复精力，从而提高战斗力，开发出更多的应用。\n"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return donateNote
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DonateTableViewCell

        // Configure the cell...
        cell.name.text = nameList[indexPath.row]
        cell.price.text = priceList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
