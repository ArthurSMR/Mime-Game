//
//  RankingFinalViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 13/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class RankingFinalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var firstAvatar: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var firstPoints: UILabel!
    
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var secondAvatar: UIImageView!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var secondPoints: UILabel!
    
    @IBOutlet weak var thirdStack: UIStackView!
    @IBOutlet weak var thirdAvatar: UIImageView!
    @IBOutlet weak var thirdName: UILabel!
    @IBOutlet weak var thirdPoints: UILabel!
    
    var sortedPlayers: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRanking()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        guard let rankingTableView = self.tableView else { return }
        PlayerRankingTableViewCell.registerNib(for: rankingTableView)
    }
    
    func setupRanking() {
        
        setupFirst()
        
        if sortedPlayers.count == 2 {
            setupSecond()
        } else if sortedPlayers.count >= 3 {
            setupSecond()
            setupThird()
        }
    }
    
    func setupFirst() {
        firstAvatar.image = sortedPlayers[0].avatar
        firstName.text = sortedPlayers[0].name
        firstPoints.text = String(sortedPlayers[0].points) + "pts"
    }
    
    func setupSecond() {
        secondAvatar.image = sortedPlayers[1].avatar
        secondName.text = sortedPlayers[1].name
        secondPoints.text = String(sortedPlayers[1].points) + "pts"
        secondStack.alpha = 1.0
    }
    
    func setupThird() {
        thirdAvatar.image = sortedPlayers[2].avatar
        thirdName.text = sortedPlayers[2].name
        thirdPoints.text = String(sortedPlayers[2].points) + "pts"
        thirdStack.alpha = 1.0
    }

    @IBAction func playAgainBtnDidPress(_ sender: Any) {
        performSegue(withIdentifier: "backToLobby", sender: nil)
    }
    
}

extension RankingFinalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let player = sortedPlayers[indexPath.row]
        
        let rankingCell = PlayerRankingTableViewCell.dequeueCell(from: tableView)
        rankingCell.ranking.text = String(indexPath.row + 1)
        rankingCell.playerName.text = player.name
        
        rankingCell.playerPoints.text = "\(player.points) pts"
        rankingCell.playerAvatar.image = player.avatar
        
        return rankingCell
    }
}
