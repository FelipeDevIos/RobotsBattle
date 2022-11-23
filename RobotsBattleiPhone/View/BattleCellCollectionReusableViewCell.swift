//
//  BattleCellCollectionReusableViewCell.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class BattleCellCollectionReusableViewCell: UICollectionViewCell {
    @IBOutlet weak var testLabel: UILabel!
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
}
