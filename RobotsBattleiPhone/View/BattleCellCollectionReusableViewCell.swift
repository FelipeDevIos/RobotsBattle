//
//  BattleCellCollectionReusableViewCell.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class BattleCellCollectionReusableViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
    
    func configure(with model: BattleCell) {
        
        switch model.type {
        case .prize:
            backView.backgroundColor = UIColor.yellow
        case .robot1:
            backView.backgroundColor = UIColor.red
        case .robot2:
            backView.backgroundColor = UIColor.blue
        default:
            backView.backgroundColor = UIColor.lightGray
        }
    }
}
