//
//  PlusMenuViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit

class PlusMenuViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
    
    // MARK: - Properties
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("添加", for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        if !picked {
            present(imagePicker, animated: true, completion: nil)
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
    
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
    }
    
    // MARK: - Textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength {
            let textCount = newString.length
            textCountLabel.text = "\((0) + textCount)/8"
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
        }
        
        return UISwipeActionsConfiguration(actions: [plusMinusAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        plusMinusTableView.deselectRow(at: indexPath, animated: true)
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
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            menuImage.contentMode = .scaleAspectFit
            menuImage.image = pickedImage
            picked = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picked = false
        dismiss(animated: true, completion: nil)
    }
    
}
