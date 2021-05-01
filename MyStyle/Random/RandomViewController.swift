//
//  RandomViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import EventKit

class RandomViewController: UIViewController {
    
    let eventStore : EKEventStore = EKEventStore()
    
    // MARK: - Random Actions
    
    func randomMenu(quantity: Int) {
        
        let title: String!
        var notes: String!
        
        title = getTitle(quantity: quantity)
        
        notes = getNote(quantity:quantity)
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
//                print("granted \(granted)")
//                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title = title
                event.startDate = Date()
                event.endDate = Date()
                event.isAllDay = true
                event.notes = notes
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
//                print("Saved Event")
            }
            else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getTitle(quantity: Int) -> String {
        switch quantity {
        case 4:
            return "三菜一汤"
        case 5:
            return "四菜一汤"
        case 8:
            return "六菜两汤"
        case 10:
            return "八菜两汤"
        default:
            return ""
        }
    }
    
    func getNote(quantity: Int) -> String {
        var notes = ""
        var materailDict: [String: Int] = [:]
        
        menus.shuffle()
        for i in 0...(quantity-1) {
            notes += (menus[i].name + "\n")
  
            for materail in menus[i].meterials {
                if materailDict[materail] != nil {
                    materailDict[materail]! += 1
                } else {
                    materailDict[materail] = 1
                }
            }
        }
        
        for (material, quantity) in materailDict {
            notes += (material + " x " + String(quantity) + "\n")
        }
        
        return notes
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
