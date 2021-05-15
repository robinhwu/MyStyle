//
//  PlusMenuViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import UIKit
import CoreData

class PlusMenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var menus: [Menu] = []
    
    private var materialItems:[Material] = []
    var fetchResultController: NSFetchedResultsController<Material>!

    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("添加", for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let sectionTitle = ["已选", "待选"]
    
    var picked: Bool!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var plusMinusTableView: UITableView!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var menuTypeSwitch: UISwitch!
    var chosen:[Material] = []
    var notChosen:[Material]!
    var menuName: String!
    var menuImage: UIImage!
    var menuImageName: String!
    
    lazy var dataSource = configureDataSource()
    var snapshot: NSDiffableDataSourceSnapshot<Int, Material>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textField.delegate = self
        plusMinusTableView.delegate = self
        plusMinusTableView.dataSource = self.dataSource
        imagePicker.delegate = self
        
        // Load material items from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            let fetchMaterialsRequest: NSFetchRequest<Material> = Material.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchMaterialsRequest.sortDescriptors = [nameSortDescriptor]
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchMaterialsRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            do {
                notChosen = try context.fetch(fetchMaterialsRequest)
            } catch {
                print("Failed to retrieve material")
                print(error)
            }
            let fetchMenusRequest: NSFetchRequest<Menu> =
                Menu.fetchRequest()
            fetchMenusRequest.sortDescriptors = [nameSortDescriptor]
            do {
                menus = try context.fetch(fetchMenusRequest)
            } catch {
                print("Failed to retrieve menu")
                print(error)
            }
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Material>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(chosen, toSection: 0)
        snapshot.appendItems(notChosen, toSection: 1)
        
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
        
        picked = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        thumbnailImageView.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Int, Material> {
        let dataSource = PlusMenuDiffableDataSource(
            tableView: plusMinusTableView,
            cellProvider: {  tableView, indexPath, material in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlusMenuTableViewCell
                
                cell.nameLabel.text = material.name
                
                cell.thumbnailImageView.backgroundColor = UIColor.randomColor()
                
                return cell
            }
        )
        return dataSource
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
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            for material in chosen {
                material.chosen = false
            }
            appDelegate.saveContext()
        }
    }
    
    
    
    @objc func fabTapped(_ button: UIButton) {
        if !picked {
            showToast(controller: self, message: "请添加菜肴图片。", seconds: 0.8)
            return
        } else if textField.text?.count == 0 {
            showToast(controller: self, message: "请输入菜肴名字。", seconds: 0.8)
            return
        } else if chosen.count == 0 {
            showToast(controller: self, message: "请添加食材。", seconds: 0.8)
            return
        } else {
            menuName = textField.text
            for menu in menus {
                if (menu.name == menuName) {
                    showToast(controller: self, message: "\(menuName!)已存在。", seconds: 0.8)
                    return
                }
            }
        }
        
        savePng(menuImage)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let menu = Menu(context: appDelegate.persistentContainer.viewContext)
            menu.name = menuName
            menu.type = menuTypeSwitch.isOn
            menu.chosen = false
            menu.isPreload = false
            menu.imageName = menuImageName
            
            for material in chosen {
                print("add \(material.name!) to \(menu.name!)")
                menu.addToMaterials(material)
            }
            
            for material in chosen {
                print("plus \(material.name!) count")
                material.count += 1
                material.chosen = false
            }
            
            print("Saving data to context ...")
            
            appDelegate.saveContext()
        }
        
        navigationController?.popToRootViewController(animated: true)
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

extension PlusMenuViewController {
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
    
    func findIndex(material selectedMaterial: Material, list materialsList: [Material])-> Int {
        for i in 0...materialsList.count-1 {
            if (materialsList[i].name == selectedMaterial.name) {
                return i
            }
        }
        return -1
    }
}

extension PlusMenuViewController: UITextFieldDelegate {
    // MARK: - Textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength {
            let textCount = newString.length
            textCountLabel.text = "\((0) + textCount)/6"
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
}

extension PlusMenuViewController: UITableViewDelegate {
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected movie
        guard let material = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let plusMinusAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let index: Int!
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([material])
            if (material.chosen == true) {
                material.chosen = false
                self.notChosen.append(material)
                index = self.findIndex(material: material, list: self.chosen)
                self.chosen.remove(at: index)
                snapshot.appendItems([material], toSection: 1)
            } else {
                material.chosen = true
                self.chosen.append(material)
                index = self.findIndex(material: material, list: self.notChosen)
                self.notChosen.remove(at: index)
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
            thumbnailImageView.contentMode = .scaleAspectFit
            thumbnailImageView.image = pickedImage
            picked = true
            menuImage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func savePng(_ image: UIImage) {
        if let pngData = image.pngData(),
           let url = documentDirectoryPath()?.appendingPathComponent("\(menuName!).png") {
            try? pngData.write(to: url)
            menuImageName = "\(menuName!).png"
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picked = false
        dismiss(animated: true, completion: nil)
    }
}


