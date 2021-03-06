//
//  RandomViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import CoreData

class RandomViewController: UIViewController {
    
    // MARK: - Properties
    
    var menus: [Menu] = []
    var fetchResultController: NSFetchedResultsController<Menu>!
    
    var randomMenusList: [Menu] = []
    var randomMaterialsList: [String] = []
    var dishes: [Menu] {
        menus.filter {
            $0.type == true
        }
    }
    var soups: [Menu] {
        menus.filter {
            $0.type == false
        }
    }
    
    // MARK: - Random Actions
    
    @IBAction func four(_ sender: Any) {
        if isEnough(quantity: 4) {
            randomMenu(quantity: 4)
            performSegue(withIdentifier: "toRandom", sender: self)
        } else {
            showToast(controller: self, message: NSLocalizedString("菜肴数量不足！", comment: "菜肴数量不足！"), seconds: 0.8)
        }
    }
    
    
    @IBAction func five(_ sender: Any) {
        if isEnough(quantity: 5) {
            randomMenu(quantity: 5)
            performSegue(withIdentifier: "toRandom", sender: self)
        } else {
            showToast(controller: self, message: NSLocalizedString("菜肴数量不足！", comment: "菜肴数量不足！"), seconds: 0.8)
        }
    }
    
    @IBAction func eight(_ sender: Any) {
        if isEnough(quantity: 8) {
            randomMenu(quantity: 8)
            performSegue(withIdentifier: "toRandom", sender: self)
        } else {
            showToast(controller: self, message: NSLocalizedString("菜肴数量不足！", comment: "菜肴数量不足！"), seconds: 0.8)
        }
    }
    
    @IBAction func ten(_ sender: Any) {
        if isEnough(quantity: 10) {
            randomMenu(quantity: 10)
            performSegue(withIdentifier: "toRandom", sender: self)
        } else {
            showToast(controller: self, message: NSLocalizedString("菜肴数量不足！", comment: "菜肴数量不足！"), seconds: 0.8)
        }
    }
    
    func isEnough(quantity: Int) -> Bool {
        switch quantity {
        case 4:
            if (dishes.count < 3 || soups.count < 1) {
                return false
            }
        case 5:
            if (dishes.count < 4 || soups.count < 1) {
                return false
            }
        case 8:
            if (dishes.count < 6 || soups.count < 2) {
                return false
            }
        case 10:
            if (dishes.count < 8 || soups.count < 2) {
                return false
            }
        default:
            fatalError()
        }
        return true
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        randomMenusList = []
        randomMaterialsList = []
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func randomMenu(quantity: Int) {
        
        menus.shuffle()
        
        for i in 0...(quantity-1) {
            randomMenusList.append(menus[i])
        }
        var randomMaterialsDict: [Material: Int] = [:]

        for menu in randomMenusList  {
            for materail in menu.materials as! Set<Material> {
                if randomMaterialsDict[materail] != nil {
                    randomMaterialsDict[materail]! += 1
                } else {
                    randomMaterialsDict[materail] = 1
                }
            }
        }

        for (material, quantity) in randomMaterialsDict {
            if material.isPreload {
                randomMaterialsList.append(NSLocalizedString(material.name!, comment: material.name!) + " x " + String(quantity))
            } else {
                randomMaterialsList.append(material.name! + " x " + String(quantity))
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RandomDetailViewController
        
        controller.randomMenusList = randomMenusList
        controller.randomMaterialsList = randomMaterialsList
    }
    
}
