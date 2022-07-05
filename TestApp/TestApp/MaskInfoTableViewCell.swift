//
//  MaskInfoTableViewCell.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/5.
//

import UIKit

class MaskInfoTableViewCell: UITableViewCell {
    var id = ""
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var adultMaskCount: UILabel!
    @IBOutlet weak var childMaskCount: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteMaskInfo(_ sender: Any) {
        NetworkController.sharedInstance.deleteMaskInfo(id: self.id)
    }
    
}
