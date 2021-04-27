//
//  DetailViewController.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/21.
//

import UIKit

class InquiryDetailViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    
    var menu: Menu!
    
    var selectedMenuMaterails: [String]!
    
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var materialListTableView: UITableView!
    
    enum Section {
        case all
    }
    
    lazy var dataSource = configureDataSource()
    
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
        
        menuImage.image = UIImage(named: menu.image)
        
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                        self.containerView.transform = CGAffineTransform.identity
                       }, completion: nil)
    }
    
    func configureView() {
        if let menu = menu {
            nameLabel.text = menu.name
            //        menuImage.image = UIImage(named: menu.image)
            selectedMenuMaterails = menu.meterials
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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
