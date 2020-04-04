//
//  LazyAnimalCell.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit


class LazyAnimalCell: UICollectionViewCell {

    static let identifier = String(describing: LazyAnimalCell.self)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var animal: LazyAnimal? {
        didSet {
            guard let animal = animal else { return }
            imageView.image = animal.image
            label.text = animal.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
    }

}
