//
//  AgacCollectionViewCell.swift
//  bitirme-projesi-deneme
//
//  Created by Kubilay Kömürcüoğlu on 22.07.2023.
//

import UIKit

class AgacCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var apiImage: UIImageView!
    @IBOutlet weak var lblAgac: UILabel!
    @IBOutlet weak var lblSubAgac: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            apiImage.layer.cornerRadius = 5
            apiImage.clipsToBounds = true
        }
}
