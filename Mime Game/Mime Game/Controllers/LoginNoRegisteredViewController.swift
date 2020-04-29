//
//  LoginNoRegisteredViewController.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 20/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class LoginNoRegisteredViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    var avaliableAvatars: [UIImage] = []
    var currentSelectedAvatarIndex: Int = 0{
        didSet{
            collectionView.cellForItem(at: IndexPath(row: currentSelectedAvatarIndex, section: 0))?.alpha = 1
            if currentSelectedAvatarIndex > 0{
                let prevIndex = currentSelectedAvatarIndex - 1
                collectionView.cellForItem(at:IndexPath(row: prevIndex, section: 0))?.alpha = 0.6
            }
            if currentSelectedAvatarIndex < avaliableAvatars.count {
                let nextIndex = currentSelectedAvatarIndex + 1
                collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0))?.alpha = 0.6
            }
        }
    }
    let cellScaling: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.avaliableAvatars = LoginNoRegisteredViewController.createAvaliableAvatarsArray()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.textField.delegate = self
        
        self.currentSelectedAvatarIndex = 0
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setupTranslucidAvatars()
//    }
    
    static func createAvaliableAvatarsArray() -> [UIImage] {
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
        
        // not working
        if indexPath.row > 0 {
            cell.alpha = 0.6
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let insetX = collectionView.frame.width * cellScaling / 2
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor(collectionView.frame.width * cellScaling)
        let cellHeight = floor(collectionView.frame.height * cellScaling)
               
        return CGSize(width: cellWidth, height: cellHeight)
    }
    

    //MARK: ScrollView Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offSet = targetContentOffset.pointee
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        self.currentSelectedAvatarIndex = Int(roundedIndex)
        
        offSet = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offSet
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
 // MARK: - Navigation
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "playButtonSegue":
        
        if let destinationVC = segue.destination as? LobbyViewController {
            destinationVC.incomingName = self.textField.text ?? "UNI a.k.a Usuário não identificado"
            destinationVC.incomingAvatar = self.avaliableAvatars[currentSelectedAvatarIndex]
            destinationVC.currentAvatarIndex = self.currentSelectedAvatarIndex
        }
        
    default:
        print("No segue found")
    }
  
 }
    
    
}
