//
//  MinusMenuTableViewCell.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/19.
//

import UIKit

class MinusMenuTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

}
