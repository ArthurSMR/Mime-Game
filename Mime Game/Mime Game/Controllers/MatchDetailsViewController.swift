//
//  MatchDetailsViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 11/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sortedPlayers: [Player]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        guard let rankingTableView = self.tableView else { return }
        PlayerRankingTableViewCell.registerNib(for: rankingTableView)
    }
}

extension MatchDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let player = sortedPlayers?[indexPath.row]
        
        let rankingCell = PlayerRankingTableViewCell.dequeueCell(from: tableView)
        rankingCell.ranking.text = String(indexPath.row + 1)
        rankingCell.playerName.text = player?.name
        rankingCell.playerPoints.text = "\(player?.points) pts"
        rankingCell.playerAvatar.image = player?.avatar
        
        return rankingCell
    }
    
    
}
