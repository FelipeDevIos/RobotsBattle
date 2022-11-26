//
//  ViewController.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 22/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resetGame: UIButton!
    @IBOutlet weak var newLoop: UIButton!
    @IBOutlet weak var relocatePrizeButton: UIButton!
    @IBOutlet weak var pauseGame: UIButton!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var redRobotWins: UILabel!
    @IBOutlet weak var blueRobotWins: UILabel!
    
    var game = Game()
    var timer: Timer?
    
    enum Constants {
        static let timeInterval: TimeInterval = 0.8
    }
    
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
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
        winnerImage.image = #imageLiteral(resourceName:  "Playing")
        
        settingControl(enable: false, newLoop)
        settingControl(enable: true, relocatePrizeButton)
    }
    
    @IBAction func resetGameTapped(_ sender: Any) {
        print("David Robot1", Records.shared.robot1, "\nRobot2", Records.shared.robot2)
        print("David new loop", Records.shared.getGameRounds())
        print("David prize relocations", Records.shared.getPrizeRelocations())
        print("David draws", Records.shared.getGameDraws())
        setUpLogic()
        
        redRobotWins.text = "\(Records.shared.robot1.totalWins) Wins"
        blueRobotWins.text = "\(Records.shared.robot2.totalWins) Wins"
        
        Records.shared.restartGame()
        Records.shared.addGameResets()
        print("David resets", Records.shared.getGameResets())
    }
    
    @IBAction func newLoopRequested(_ sender: Any) {
        setUpLogic()
        collectionView.reloadData()
        
        Records.shared.addGameRounds()
        print("David new loop", Records.shared.getGameRounds())
    }
    
    @IBAction func relocatePrize(_ sender: Any) {
        relocatePrize()
        collectionView.reloadData()
    }
    
    private func relocatePrize() {
        guard let prizeIndex = game.playedCells.firstIndex(where: {$0.type == .prize}) else { return }

        let newPrizePosition = Position.generatePosition(for: Position.Ranges.prize)
        
        guard game.playedCells.isAValidCell(newPrizePosition) else {
            relocatePrize()
            return
        }
        
        let prizeCell = BattleCell(position: newPrizePosition, type: .prize)
        game.playedCells[prizeIndex].position = newPrizePosition
        game.prize.position = prizeCell.position
        
        Records.shared.addPrizeRelocation()
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        pauseResumeTimer()
    }
    
    private func pauseResumeTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
            pauseGame.setTitle("Pause", for: .normal)
        } else {
            timer?.invalidate()
            timer = nil
            pauseGame.setTitle("Resume", for: .normal)
        }
    }
    
    @objc func plays() {
        if game.robot1 == nil && game.robot2 == nil {
            timer?.invalidate()
            winnerImage.image = #imageLiteral(resourceName: "draw")
            Records.shared.addGameDraw()
            settingControl(enable: false, relocatePrizeButton)
            settingControl(enable: true, newLoop)
            return
        } else if game.onTurn == .robot1 {
            guard let robot1 = game.robot1, let nextCell = game.robot1?.findingBestNextCell(using: game) else {
                game.robot1 = nil
                game.onTurn = .robot2
                return
            }
            
            robot1.position = nextCell
            let cell = BattleCell(position: robot1.position, type: .robot1)
            game.playedCells.append(cell)
            robot1.path.append(cell)
            game.robot1 = robot1
            game.onTurn = .robot2
            
            Records.shared.robot1.addingSteps()
        } else if game.onTurn == .robot2 {
            guard let robot2 = game.robot2, let nextCell = robot2.findingBestNextCell(using: game) else {
                game.robot2 = nil
                game.onTurn = .robot1
                return
            }
            
            robot2.position = nextCell
            let cell = BattleCell(position: robot2.position, type: .robot2)
            game.playedCells.append(cell)
            robot2.path.append(cell)
            game.robot2 = robot2
            game.onTurn = .robot1
            
            Records.shared.robot2.addingSteps()
        }
        
        let gameOver = game.gameOver()
        if gameOver.result {
            if let prizeIndex = game.playedCells.firstIndex(where: {$0.type == .prize}) {
                game.playedCells[prizeIndex].type = .capture
                settingControl(enable: false, relocatePrizeButton)
            }

            timer?.invalidate()
            
            switch gameOver.winner {
            case .robot1 :
                game.robot1?.wins += 1
                winnerImage.image = #imageLiteral(resourceName:  "R1_winner")
            case .robot2 :
                game.robot2?.wins += 1
                winnerImage.image = #imageLiteral(resourceName:  "R2_winner")
            default: break
            }
            
            redRobotWins.text = "\(Records.shared.robot1.totalWins) Wins"
            blueRobotWins.text = "\(Records.shared.robot2.totalWins) Wins"
            
            settingControl(enable: true, newLoop)
        }
        
        collectionView.reloadData()
    }
    
    func settingControl(enable: Bool, _ button: UIButton) {
        button.isUserInteractionEnabled = enable
        button.isEnabled = enable
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
            let fractionHeight: CGFloat = 1 / 7
            let inset: CGFloat = 0.5
            
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

