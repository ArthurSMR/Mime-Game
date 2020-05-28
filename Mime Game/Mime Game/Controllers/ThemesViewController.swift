//
//  ThemesViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 27/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var themes: Themes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        MimeServices.fetchThemes { (themes, error) in
            if let error = error {
                print(error)
            }
            self.themes = themes
        }
        self.prepareTableView()
    }
    
    func prepareTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        ThemeTableViewCell.registerNib(for: table)
    }
}

extension ThemesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ThemeTableViewCell.dequeueCell(from: tableView)
        let theme = self.themes.themes[indexPath.row]
        
        cell.themeLbl.text = theme.name
        return cell
    }
}
