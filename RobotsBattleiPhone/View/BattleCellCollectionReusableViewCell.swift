//
//  BattleCellCollectionReusableViewCell.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class BattleCellCollectionReusableViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backView.backgroundColor = UIColor(named: "cell_background")
        imageView.image = nil
    }
    
    func configure(with model: BattleCell) {
        
        switch model.type {
        case .prize:
            imageView.image = UIImage(named: "trophy")
        case .robot1:
            imageView.image = UIImage(named: "red_robot")
        case .robot2:
            imageView.image = UIImage(named: "blue_robot")
        case .capture:
            imageView.image = UIImage(named: "capture")
        default:
            break
        }
    }
}
