//
//  InquiryViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/15.
//

import UIKit

class InquiryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var inquiryTableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    
    var searchController: UISearchController!
    
    var result: [Menu] = []
    var categoryMenu: [Menu] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive &&
            (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    
    // MARJL - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        inquiryTableView.dataSource = self
        inquiryTableView.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "请输入要查找的菜肴..."
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
//        present(searchController, animated: true, completion: nil)
        searchController.searchBar.scopeButtonTitles = ["All", "Dish", "Soup"]
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillChangeFrameNotification,
          object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillHideNotification,
          object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }
    
    // MARK: - Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount:
                  result.count, of: categoryMenu.count)
            return result.count
        } else {
            searchFooter.setNotFiltering()
            return menus.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InquiryTableViewCell
        
        let menu = (isFiltering) ? result[indexPath.row] : menus[indexPath.row]
        
        cell.nameLabel.text = menu.name
        cell.thumbnailImageView.image = UIImage(named: menu.image)
        return cell
    }
    
    func filterContent(for searchText: String, category: String) {
        switch category {
        case "Dish":
            categoryMenu = menus.filter( {(menu) -> Bool in
                return menu.type
            })
        case "Soup":
            categoryMenu = menus.filter( {(menu) -> Bool in
                return !menu.type
            })
        default:
            categoryMenu = menus
        }
        
        if isSearchBarEmpty {
            result = categoryMenu
        } else {
            result = categoryMenu.filter({ (menu) -> Bool in
                let isMatch = menu.name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
        }

        inquiryTableView.reloadData()
    }
    
    func handleKeyboard(notification: Notification) {
      // 1
      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
        searchFooterBottomConstraint.constant = 0
        view.layoutIfNeeded()
        return
      }

      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
          return
      }

      // 2
      let keyboardHeight = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.searchFooterBottomConstraint.constant = keyboardHeight
        self.view.layoutIfNeeded()
      })
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
          segue.identifier == "ShowDetailSegue",
          let indexPath = inquiryTableView.indexPathForSelectedRow,
          let detailViewController = segue.destination as? InquiryDetailViewController
        else {
          return
        }
        
        let menu = (isFiltering) ? result[indexPath.row] : menus[indexPath.row]
        detailViewController.menu = menu
    }
}

extension InquiryViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
      let category =
        searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContent(for: searchBar.text!, category: category)
  }
}

extension InquiryViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category =
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContent(for: searchBar.text!, category: category)
  }
}
