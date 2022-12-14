//
//  ViewController.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 22/11/22.
//

import UIKit

class BoardViewController: UIViewController {
    @IBOutlet weak var resetGameButton: UIButton!
    @IBOutlet weak var newLoopButton: UIButton!
    @IBOutlet weak var relocatePrizeButton: UIButton!
    @IBOutlet weak var pauseGameButton: UIButton!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var redRobotWinsLabel: UILabel!
    @IBOutlet weak var blueRobotWinsLabel: UILabel!
    
    var game = Game()
    var timer: Timer?
    
    enum Constants {
        static let timeInterval: TimeInterval = 0.8
        static let wins: String = "Win(s)"
        static let resume: String = "Resume"
        static let pause: String = "Pause"
        static let rows: Int = boardLimits.max
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(UINib(nibName: BattleCellCollectionReusableViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: BattleCellCollectionReusableViewCell.reusableIdentifier)
        
        setUpLogic()
    }
    
    /// Resets game
    /// - Parameter sender: UI button
    @IBAction func resetGameTapped(_ sender: Any) {
        setUpLogic()
        
        settingControl(enable: true, pauseGameButton)
        
        Records.shared.restartGame()
        Records.shared.addGameResets()
        
        showScores()
        
        print("Reset scores", Records.shared.summary())
    }
    
    /// Requests new loop for game
    /// - Parameter sender: UI Button
    @IBAction func newLoopRequested(_ sender: Any) {
        setUpLogic()
        
        Records.shared.addGameRounds()
        
        print("New Loop", Records.shared.summary())
    }
    
    /// Relocates the prize
    /// - Parameter sender: UI Button
    @IBAction func relocatePrize(_ sender: Any) {
        game.relocatePrize()
        collectionView.reloadData()
    }
    
    /// Pauses the game
    /// - Parameter sender: UI Button
    @IBAction func pauseGame(_ sender: Any) {
        pauseResumeTimer()
        Records.shared.addGamePause()
    }
}

extension BoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.rows
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.rows
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

extension BoardViewController {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(_, _) -> NSCollectionLayoutSection? in
            let fractionWidth: CGFloat = 1 / CGFloat(Constants.rows)
            let fractionHeight: CGFloat = 1 / CGFloat(Constants.rows)
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

extension BoardViewController: UpdateViewStateProtocol {
    func updateBoard() {
        collectionView.reloadData()
    }
    
    func updateScores() {
        showScores()
    }
    
    func showWinner(with image: WinImages) {
        winnerImage.image = UIImage(named: image.rawValue)
    }
    
    func setButton(enable: Bool, button: AvailableButtons) {
        var control: UIButton
        
        switch button {
        case .newLoop:
            control = newLoopButton
        case .relocatePrizeButton:
            control = relocatePrizeButton
        case .pauseResume:
            control = pauseGameButton
        }
        
        settingControl(enable: enable, control)
    }
}

extension BoardViewController: TimeManageProtocol {
    func invalidateTime() {
        timer?.invalidate()
    }
}
