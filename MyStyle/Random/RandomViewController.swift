//
//  RandomViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import EventKit

class RandomViewController: UIViewController {
    
    // MARK: - Properties
    
    var randomMenusList: [Menu] = []
    var randomMaterialsList: [String] = []
    
    // MARK: - Random Actions
    
    @IBAction func four(_ sender: Any) {
        randomMenu(quantity: 4)
        performSegue(withIdentifier: "toRandom", sender: self)
    }
    
    
    @IBAction func five(_ sender: Any) {
        randomMenu(quantity: 5)
        performSegue(withIdentifier: "toRandom", sender: self)
    }
    
    @IBAction func eight(_ sender: Any) {
        randomMenu(quantity: 8)
        performSegue(withIdentifier: "toRandom", sender: self)
    }
    
    @IBAction func ten(_ sender: Any) {
        randomMenu(quantity: 10)
        performSegue(withIdentifier: "toRandom", sender: self)
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        var randomMaterialsDict: [String: Int] = [:]

        for menu in randomMenusList {

            for materail in menu.meterials {
                if randomMaterialsDict[materail] != nil {
                    randomMaterialsDict[materail]! += 1
                } else {
                    randomMaterialsDict[materail] = 1
                }
            }
        }

        for (material, quantity) in randomMaterialsDict {
            randomMaterialsList.append(material + " x " + String(quantity))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RandomDetailViewController
        
        controller.randomMenusList = randomMenusList
        controller.randomMaterialsList = randomMaterialsList
    }
    
}
