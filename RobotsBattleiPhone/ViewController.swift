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
        static let wins: String = "Win(s)"
        static let resume: String = "Resume"
        static let pause: String = "Pause"
        static let rows: Int = 7
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
        game.timeManageDelegate = self
        game.updateViewDelegate =  self
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
        winnerImage.image = #imageLiteral(resourceName:  "Playing")
        
        settingControl(enable: false, newLoop)
        settingControl(enable: true, relocatePrizeButton)
        settingControl(enable: true, pauseGame)
        
        collectionView.reloadData()
    }
    
    @IBAction func resetGameTapped(_ sender: Any) {
        setUpLogic()
        
        settingControl(enable: true, pauseGame)
        
        Records.shared.restartGame()
        Records.shared.addGameResets()
        
        showScores()
    }
    
    @IBAction func newLoopRequested(_ sender: Any) {
        setUpLogic()
        
        Records.shared.addGameRounds()
    }
    
    @IBAction func relocatePrize(_ sender: Any) {
        game.relocatePrize()
        collectionView.reloadData()
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        pauseResumeTimer()
    }
    
    private func showScores() {
        redRobotWins.text = "\(Records.shared.robot1.totalWins) \(Constants.wins)"
        blueRobotWins.text = "\(Records.shared.robot2.totalWins) \(Constants.wins)"
    }
    
    private func pauseResumeTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
            pauseGame.setTitle(Constants.pause, for: .normal)
        } else {
            timer?.invalidate()
            timer = nil
            pauseGame.setTitle(Constants.resume, for: .normal)
        }
    }
    
    func settingControl(enable: Bool, _ button: UIButton) {
        button.isUserInteractionEnabled = enable
        button.isEnabled = enable
    }
    
    @objc func plays() {
        game.plays()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension ViewController: UpdateViewStateProtocol {
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
            control = newLoop
        case .relocatePrizeButton:
            control = relocatePrizeButton
        case .pauseResume:
            control = pauseGame
        }
        
        settingControl(enable: enable, control)
    }
}

extension ViewController: TimeManageProtocol {
    func invalidateTime() {
        timer?.invalidate()
    }
}
