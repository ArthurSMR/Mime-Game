//
//  selectRoomViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class SelectRoomViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        prepareTableView()
    }
    
    func prepareTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        SelectRomTableViewCell.registerNib(for: table)
    }
}

extension SelectRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SelectRomTableViewCell.dequeueCell(from: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
