//
//  ViewController.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resetGame: UIButton!
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var game = Game()
    var playedCells = [BattleCell]()
    var onTurn: GameElements = .robot1
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(UINib(nibName: BattleCellCollectionReusableViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: BattleCellCollectionReusableViewCell.reusableIdentifier)
        
        setUpLogic()
    }
    
    func setUpLogic() {
        let prize = game.prize
        let robot1 = game.robot1
        let robot2 = game.robot2
        
        playedCells.append(BattleCell(position: game.prize.position, type: .prize))
        playedCells.append(BattleCell(position: game.robot1.position, type: .robot1))
        playedCells.append(BattleCell(position: game.robot2.position, type: .robot2))

        collectionView.reloadData()
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetGameTapped(_ sender: Any) {
        game = Game()
        playedCells.removeAll()
        setUpLogic()
        collectionView.reloadData()
        
        startGame.isUserInteractionEnabled = true
        startGame.setTitle("Next Move", for: .normal)
    }

    @IBAction func startGameTapped(_ sender: Any) {
        game.robot1 = game.robot1.findingBestNextCell(to: game.prize)
        playedCells.append(BattleCell(position: game.robot1.position, type: .robot1))
        
        game.robot2 = game.robot2.findingBestNextCell(to: game.prize)
        playedCells.append(BattleCell(position: game.robot2.position, type: .robot2))

        collectionView.reloadData()
        
        let gameOver = gameOver()
        if gameOver.result {
            startGame.isUserInteractionEnabled = false
            startGame.setTitle(gameOver.winner.rawValue, for: .normal)
        }
    }
    
    @objc func plays() {
        if onTurn == .robot1 {
            game.robot1 = game.robot1.findingBestNextCell(to: game.prize)
            playedCells.append(BattleCell(position: game.robot1.position, type: .robot1))
            onTurn = .robot2
        } else {
            game.robot2 = game.robot2.findingBestNextCell(to: game.prize)
            playedCells.append(BattleCell(position: game.robot2.position, type: .robot2))
            onTurn = .robot1
        }
        
        collectionView.reloadData()
        
        let gameOver = gameOver()
        if gameOver.result {
            startGame.isUserInteractionEnabled = false
            startGame.setTitle(gameOver.winner.rawValue, for: .normal)
            timer.invalidate()
        }
    }
    
    func gameOver() -> (result: Bool, winner: GameElements) {
        let robot1 = game.robot1.position == game.prize.position
        let robot2 = game.robot2.position == game.prize.position
        let winner = robot1 ? GameElements.robot1 : robot2 ? GameElements.robot2 : GameElements.prize
        
        return (robot1 || robot2, winner)
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
        var cellData: BattleCell = BattleCell(position: cellPosition)
        
        if let playedCell = playedCells.first(where: {$0.position == cellPosition}) {
            cellData = playedCell
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
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            return section
        }
        
        return layout
    }
}

