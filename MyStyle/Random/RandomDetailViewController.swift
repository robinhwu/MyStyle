//
//  RandomDetailViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/5/10.
//

import UIKit

class RandomDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Properties
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    var checked = [Bool]()
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("返回", for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let sectionTitle = ["菜肴", "食材"]
    var randomMenusList: [Menu]!
    var randomMaterialsList: [String]!
    
    @IBOutlet weak var randomTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        randomTableView.delegate = self
        randomTableView.dataSource = self
        checked = Array(repeating: false, count: randomMaterialsList.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = keyWindow {
            view.addSubview(faButton)
            setupButton()
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
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return randomMenusList.count
        case 1:
            return randomMaterialsList.count
        default:
            fatalError()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! RandomMenusTableViewCell
            cell.nameLabel.text = randomMenusList[indexPath.row].name
            cell.thumbnailImageView.image = UIImage(named: randomMenusList[indexPath.row].imagePath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Material", for: indexPath) as! RandomMaterailsTableViewCell
            cell.nameLabel.text = randomMaterialsList[indexPath.row]
            cell.thumbnailImageView.backgroundColor = UIColor.randomColor()
            
            //configure you cell here.
            if checked[indexPath.row] == false{
                cell.accessoryType = .none
            } else if checked[indexPath.row] {
                cell.accessoryType = .checkmark
            }
            return cell
        default:
            fatalError()
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    checked[indexPath.row] = false
                } else {
                    cell.accessoryType = .checkmark
                    checked[indexPath.row] = true
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
    
    @objc func fabTapped(_ button: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
