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
    
    /// Images for UI game state representation
    enum Constants {
        static let trophy = "trophy"
        static let redRobot = "red_robot"
        static let blueRobot = "blue_robot"
        static let capture = "capture"
    }
    
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backView.backgroundColor = UIColor(named: "cell_background")
        imageView.image = nil
    }
    
    /// Configures the cell's UI
    /// - Parameter model: BattleCell represnting each cell data
    func configure(with model: BattleCell) {
        switch model.type {
        case .prize:
            imageView.image = #imageLiteral(resourceName:  Constants.trophy)
        case .robot1:
            imageView.image = #imageLiteral(resourceName:  Constants.redRobot)
        case .robot2:
            imageView.image = #imageLiteral(resourceName:  Constants.blueRobot)
        case .capture:
            imageView.image = #imageLiteral(resourceName:  Constants.capture)
        default:
            break
        }
    }
}
