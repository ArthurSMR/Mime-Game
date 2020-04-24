//
//  LoginNoRegisteredViewController.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 20/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class LoginNoRegisteredViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    var avaliableAvatars: [UIImage] = []
    let cellScaling: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avaliableAvatars = createAvaliableAvatarsArray()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        collectionView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    

    
    func createAvaliableAvatarsArray() -> [UIImage] {
        var avatarsImages: [UIImage] = []
        let imageURLArray = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "test-no-register-avatars")! as [NSURL]
        
        for url in imageURLArray {
            let avatarImage = UIImage(contentsOfFile: url.path!)
           
            avatarsImages.append(avatarImage!)
        }
        
        return avatarsImages
    }
    
    //MARK: Collection View Delegate and DataSource:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avaliableAvatars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier, for: indexPath) as! AvatarCell
        cell.avatar = avaliableAvatars[indexPath.row]
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(collectionView.frame.width * cellScaling)
        let cellHeight = floor(collectionView.frame.height * cellScaling)

        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0

        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
//        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    

    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let character = items[(indexPath as NSIndexPath).row]
//        let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//
//

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
}
