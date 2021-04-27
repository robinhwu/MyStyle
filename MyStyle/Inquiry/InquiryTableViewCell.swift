//
//  InquiryTableViewCell.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/20.
//

import UIKit

class InquiryTableViewCell: UITableViewCell {

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

}
