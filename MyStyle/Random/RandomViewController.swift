//
//  RandomViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class RandomViewController: UIViewController {

    // MARK: - Random Actions
    
    func randomMenu(quantity: Int) {
        menus.shuffle()
        for i in 0...(quantity-1) {
            print(menus[i].name ?? "")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func four(_ sender: Any) {
        randomMenu(quantity: 4)
    }
    
    
    @IBAction func five(_ sender: Any) {
        randomMenu(quantity: 5)
    }
    
    @IBAction func eight(_ sender: Any) {
        randomMenu(quantity: 8)
    }
    
    @IBAction func ten(_ sender: Any) {
        randomMenu(quantity: 10)
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

}
