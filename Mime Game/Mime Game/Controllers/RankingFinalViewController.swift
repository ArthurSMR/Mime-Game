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
    
    var sortedPlayers: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        guard let rankingTableView = self.tableView else { return }
        PlayerRankingTableViewCell.registerNib(for: rankingTableView)
    }

    @IBAction func navigateToLobbyAction(_ sender: UIButton) {
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
