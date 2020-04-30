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
    var currentSelectedAvatarIndex: Int = 0
    let cellScaling: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.avaliableAvatars = LoginNoRegisteredViewController.createAvaliableAvatarsArray()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.textField.delegate = self
        self.currentSelectedAvatarIndex = 0
        
        setupReturningPlayerInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil) { (result) in
                self.calculateAvatarCellAlpha(scrollView: self.collectionView)
            }
        }
    }
    
    static func createAvaliableAvatarsArray() -> [UIImage] {
        var avatarsImages: [UIImage] = []
        var n: Int = 1
        
        while let avatarImage = UIImage(named: "Avatar\(n)"){
            avatarsImages.append(avatarImage)
            n += 1
        }
        return avatarsImages
    }
    
    func calculateAvatarCellAlpha(scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        for visibleIndex in collectionView.indexPathsForVisibleItems {
            let cell = collectionView.cellForItem(at: visibleIndex) as? AvatarCell
            if visibleIndex == visibleIndexPath {
                cell?.imageView.alpha = 1.0
            } else {
                cell?.imageView.alpha = 0.6
            }
        }
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
        cell.imageView.image = avaliableAvatars[indexPath.row]
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateAvatarCellAlpha(scrollView: scrollView)
    }
    
    //MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    //MARK: - Returning Player
    func setupReturningPlayerInfo(){
        if let returningNotRegisteredPlayer = UserServices.retrieveCurrentUser() {
            self.textField.text = returningNotRegisteredPlayer.userName!
            self.collectionView.scrollToItem(at: IndexPath(row: returningNotRegisteredPlayer.avatarIndex!, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "playButtonSegue":
            
            if let destinationVC = segue.destination as? LobbyViewController {
                destinationVC.incomingName = self.textField.text ?? "UNI a.k.a Usuário não identificado"
                destinationVC.incomingAvatar = self.avaliableAvatars[currentSelectedAvatarIndex]
                destinationVC.currentAvatarIndex = self.currentSelectedAvatarIndex
                
                let noRegisteredUser = NoRegisteredPlayerCodable()
                noRegisteredUser.userName = self.textField.text ?? "UNI a.k.a Usuário não identificado"
                noRegisteredUser.avatarIndex = self.currentSelectedAvatarIndex
                UserServices.saveCurrentUser(user: noRegisteredUser)
            }
            
        default:
            print("No segue found")
        }
    }
}
