//
//  JobCell.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 14/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    @IBOutlet weak var employer: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var jobDescribtion: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var jobCover: UIImageView!
    @IBOutlet weak var offer: UILabel!
    override func awakeFromNib() {super.awakeFromNib()}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
