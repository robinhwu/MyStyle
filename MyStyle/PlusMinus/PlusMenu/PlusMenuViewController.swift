//
//  PlusMenuViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class PlusMenuViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
    
    // MARK: - Properties
    
    let sectionTitle = ["已选", "待选"]
    
    var picked: Bool!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var menuImage: RoundedCornerImageView!
    
    @IBOutlet weak var plusMinusTableView: UITableView!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var chosen:[Material] = []
    var notChosen = materials
    
    var dataSource: PlusMenuDiffableDataSource!
    var snapshot: NSDiffableDataSourceSnapshot<Int, Material>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = PlusMenuDiffableDataSource(tableView: plusMinusTableView, cellProvider: { (tableView, indexPath, material) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlusMenuTableViewCell
            cell.nameLabel.text = material.name
            cell.thumbnailImageView.backgroundColor = UIColor.randomColor()
            return cell
        })
        
        // Do any additional setup after loading the view.
        textField.delegate = self
        plusMinusTableView.delegate = self
        plusMinusTableView.dataSource = dataSource
        imagePicker.delegate = self
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Material>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(materials, toSection: 1)
        
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
        
        picked = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        menuImage.isUserInteractionEnabled = true
        menuImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        if !picked {
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength {
            let textCount = newString.length
            textCountLabel.text = "\((0) + textCount)/10"
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //        self.view.endEditing(true)
        return true
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected movie
        guard var material = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let plusMinusAction = UIContextualAction(style: .destructive, title: "加") { (action, view, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([material])
            if (material.chosen == true) {
                material.chosen = false
                snapshot.appendItems([material], toSection: 1)
            } else {
                material.chosen = true
                snapshot.appendItems([material], toSection: 0)
            }
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        if (material.chosen == true) {
            plusMinusAction.backgroundColor = UIColor.systemRed
            plusMinusAction.image = UIImage(systemName: "trash")
        } else {
            plusMinusAction.backgroundColor = UIColor.systemGreen
            plusMinusAction.image = UIImage(systemName: "heart")
            plusMinusAction.title = "Add"
        }
        
        return UISwipeActionsConfiguration(actions: [plusMinusAction])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    // MARK: - HeaderInSection
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        label.textColor = UIColor.black
        label.font = UIFont(name: "Arial", size: 30)
        label.text = sectionTitle[section]
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension PlusMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            menuImage.contentMode = .scaleAspectFit
            menuImage.image = pickedImage
            picked = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
