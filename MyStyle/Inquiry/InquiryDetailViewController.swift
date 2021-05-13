//
//  DetailViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/21.
//

import UIKit

class InquiryDetailViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("返回", for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    var menu: Menu!
    
    var selectedMenuMaterails: [String] = []
    
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var materialListTableView: UITableView!
    
    enum Section {
        case all
    }
    
    lazy var dataSource = configureDataSource()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        // Do any additional setup after loading the view.
        
        materialListTableView.delegate = self
        materialListTableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(selectedMenuMaterails, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        menuImage.image = UIImage(named: menu.imageName!)
        
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.8,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                        self.containerView.transform = CGAffineTransform.identity
                       }, completion: nil)
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
    
    func configureView() {
        if let menu = menu {
            nameLabel.text = menu.name
//            for material in menu.meterials {
//                selectedMenuMaterails.append(material.name)
//            }
        }
    }
    
    // MARK: - Table view data source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: materialListTableView,
            cellProvider: {  tableView, indexPath, materail in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InquiryDetailTableViewCell
                
                cell.nameLabel.text = materail
                return cell
            }
        )
        return dataSource
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
        dismiss(animated: true, completion: nil)
    }
}
