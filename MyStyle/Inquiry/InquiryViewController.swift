//
//  InquiryViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/15.
//

import UIKit
import AVFoundation
import CoreData

class InquiryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    
    var menus: [Menu] = []
    var fetchResultController: NSFetchedResultsController<Menu>!
    
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
    
    var audioPlayer: AVAudioPlayer!
    
    // MARK: - Lifecycle
    
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
        
        searchController.searchBar.scopeButtonTitles = ["全部", "菜", "汤"]
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
                menus = try context.fetch(fetchRequest)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
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
        cell.thumbnailImageView.image = UIImage(named: menu.imageName!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = Bundle.main.path(forResource: "close.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        
        inquiryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func filterContent(for searchText: String, category: String) {
        switch category {
        case "菜":
            categoryMenu = menus.filter( {(menu) -> Bool in
                return menu.type
            })
        case "汤":
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
                let isMatch = menu.name!.localizedCaseInsensitiveContains(searchText)
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
