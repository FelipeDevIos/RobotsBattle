//
//  ViewController.swift
//  RobotsBattleiPhone
//
//  Created by Felipe Velandia  on 22/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resetGame: UIButton!
    @IBOutlet weak var newLoop: UIButton!
    @IBOutlet weak var pauseGame: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var redRobotWins: UILabel!
    @IBOutlet weak var blueRobotWins: UILabel!
    
    var game = Game()
    var onTurn: GameElements = .robot1
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(UINib(nibName: BattleCellCollectionReusableViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: BattleCellCollectionReusableViewCell.reusableIdentifier)
        
        setUpLogic()
    }
    
    func setUpLogic() {
        game = Game()

        collectionView.reloadData()
//        newLoop.isUserInteractionEnabled = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetGameTapped(_ sender: Any) {
        setUpLogic()
        Records.shared.restartGame()
        redRobotWins.text = "\(Records.shared.robot1Wins) Wins"
        blueRobotWins.text = "\(Records.shared.robot2Wins) Wins"
    }
    
    @IBAction func newLoopRequested(_ sender: Any) {
        setUpLogic()
        collectionView.reloadData()
    }
    
    @IBAction func relocatePrize(_ sender: Any) {
        relocatePrize()
        collectionView.reloadData()
    }
    
    private func relocatePrize() {
        pauseResumeTimer()
        if let prizeIndex = game.playedCells.firstIndex(where: {$0.type == .capture || $0.type == .prize}) {
            let newPrizePosition = Position.generatePosition(for: Position.Ranges.prize)
            
            guard game.playedCells.isAValidCell(newPrizePosition) else {
                relocatePrize()
                return
            }
            
            game.playedCells[prizeIndex].position = newPrizePosition
            game.prize.position = newPrizePosition
            pauseResumeTimer()
        }
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        pauseResumeTimer()
    }
    
    private func pauseResumeTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
            pauseGame.setTitle("Pause", for: .normal)
        } else {
            timer?.invalidate()
            timer = nil
            pauseGame.setTitle("Resume", for: .normal)
        }
    }
    
    @objc func plays() {
        if onTurn == .robot1 {
            guard let nextCell = game.robot1.findingBestNextCell(using: game) else {
                onTurn = .robot2
                return
            }
            
            game.robot1.position = nextCell
            let cell = BattleCell(position: game.robot1.position, type: .robot1)
            game.playedCells.append(cell)
            game.robot1.path.append(cell)
            
            onTurn = .robot2
        } else {
            guard let nextCell = game.robot2.findingBestNextCell(using: game) else {
                onTurn = .robot1
                return
            }
            game.robot2.position = nextCell
            let cell = BattleCell(position: game.robot2.position, type: .robot2)
            game.playedCells.append(cell)
            game.robot2.path.append(cell)
            
            onTurn = .robot1
        }
        
        let gameOver = gameOver()
        if gameOver.result {
            if let prizeIndex = game.playedCells.firstIndex(where: {$0.type == .prize}) {
                game.playedCells[prizeIndex].type = .capture
            }
            
//            newLoop.isUserInteractionEnabled = true
            timer?.invalidate()
            
            redRobotWins.text = "\(Records.shared.robot1Wins) Wins"
            blueRobotWins.text = "\(Records.shared.robot2Wins) Wins"
        }
        
        collectionView.reloadData()
    }
    
    func gameOver() -> (result: Bool, winner: GameElements) {
        let robot1 = game.robot1.position == game.prize.position
        let robot2 = game.robot2.position == game.prize.position
        let winner = robot1 ? GameElements.robot1 : robot2 ? GameElements.robot2 : GameElements.prize
        
        switch winner {
        case .robot1: Records.shared.robot1Wins += 1
        case .robot2: Records.shared.robot2Wins += 1
        default: break
        }
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BattleCellCollectionReusableViewCell.reusableIdentifier, for: indexPath) as? BattleCellCollectionReusableViewCell ?? BattleCellCollectionReusableViewCell()
        
        let cellPosition = Position(x: indexPath.section + 1, y: indexPath.item + 1)
        var cellData: BattleCell = BattleCell(position: cellPosition)
        
        if let playedCell = game.playedCells.first(where: {$0.position == cellPosition}) {
            cellData = playedCell
        }
        
        cell.configure(with: cellData)
        
        return cell
    }
}

extension ViewController {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(_, _) -> NSCollectionLayoutSection? in
            let fractionWidth: CGFloat = 1 / 7
            let fractionHeight: CGFloat = 1 / 8
            let inset: CGFloat = 1
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fractionHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            return section
        }
        
        return layout
    }
}

