//
//  ViewController.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resetGame: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(UINib(nibName: BattleCellCollectionReusableViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: BattleCellCollectionReusableViewCell.reusableIdentifier)
    }
    
    func setUpLogic() {
        let prize = game.prize
        let robot1 = game.robot1
        let robot2 = game.robot2
        
        print(prize.position, "\n R1:", robot1.position, "\n R2:",robot2.position)

        robot1.findingBestPath(for: robot1, to: prize)
        robot2.findingBestPath(for: robot2, to: prize)
        
        print(robot1.findingBestNextCell(to: prize))
        print(robot2.findingBestNextCell(to: prize))
    }
    
    @IBAction func resetGameTapped(_ sender: Any) {
        game = Game()
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BattleCellCollectionReusableViewCell", for: indexPath) as? BattleCellCollectionReusableViewCell ?? BattleCellCollectionReusableViewCell()
        
        
        let cellPosition = Position(x: indexPath.section + 1, y: indexPath.item + 1)
        var cellData: BattleCell
        
        switch cellPosition {
        case game.prize.position:
            cellData = BattleCell(position: cellPosition, type: .prize)
        case game.robot1.position:
            cellData = BattleCell(position: cellPosition, type: .robot1)
        case game.robot2.position:
            cellData = BattleCell(position: cellPosition, type: .robot2)
        default:
            cellData = BattleCell(position: cellPosition)
        }
        
        cell.configure(with: cellData)
        
        return cell
    }
}

extension ViewController {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(_, _) -> NSCollectionLayoutSection? in
            let fraction: CGFloat = 1 / 7
            let inset: CGFloat = 1
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            return section
        }
        
        return layout
    }
}

