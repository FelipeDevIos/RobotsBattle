//
//  BattleCellCollectionReusableViewCell.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 22/11/22.
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
            imageView.image = #imageLiteral(resourceName:  "trophy")
        case .robot1:
            imageView.image = #imageLiteral(resourceName:  "red_robot")
        case .robot2:
            imageView.image = #imageLiteral(resourceName:  "blue_robot")
        case .capture:
            imageView.image = #imageLiteral(resourceName:  "capture")
        default:
            break
        }
    }
}
