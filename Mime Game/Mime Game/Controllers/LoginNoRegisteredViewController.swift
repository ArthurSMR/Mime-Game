//
//  LoginNoRegisteredViewController.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 20/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginNoRegisteredViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: Variables
    var avaliableAvatars: [UIImage] = []
    var currentSelectedAvatarIndex: Int = 0
    
    /// Percentage factor of scaling.
    /// Used on calculating collectionView insets and cell size.
    let cellScaling: CGFloat = 0.5
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Calculates AvatarCell visibility (review)
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil) { (result) in
                self.calculateAvatarCellAlpha(scrollView: self.collectionView)
            }
        }
    }
    
    //MARK: Methods
    func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.avaliableAvatars = LoginNoRegisteredViewController.createAvaliableAvatarsArray()
        prepereCollectionView()
        prepareTextField()
        self.currentSelectedAvatarIndex = 0
        
        self.setupReturningPlayerInfo()
        
    }
    
    func prepereCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func prepareTextField() {
        self.textField.delegate = self
    }
    
    /// Initialize avatar images avaliable for the player based on image's names on xcAssets
    /// - Returns: An array of UIImages for avatar selection.
    static func createAvaliableAvatarsArray() -> [UIImage] {
        
        var avatarsImages: [UIImage] = []
        var n: Int = 1
        
        while let avatarImage = UIImage(named: "Avatar\(n)"){
            avatarsImages.append(avatarImage)
            n += 1
        }
        return avatarsImages
    }
    
    /// Calculates AvatarCell Alpha factor based on cell's visibility.
    /// This method makes the centered avatar image alpha to 1 while keeping the others at 0.6.
    /// - Parameter scrollView: Avatar's CollectionView
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

//MARK: CollectionView
extension LoginNoRegisteredViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avaliableAvatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier,
                                                      for: indexPath) as! AvatarCell
        
        cell.imageView.image = avaliableAvatars[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let insetX = collectionView.frame.width * cellScaling / 2
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor(collectionView.frame.width * cellScaling)
        let cellHeight = floor(collectionView.frame.height * cellScaling)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK: ScrollView Delegate
extension LoginNoRegisteredViewController:  UIScrollViewDelegate {
    
    /// This method is responsible for keeping an avatar centered at the carroussel collection view at all times.
    /// - Parameters:
    ///   - scrollView: The scroll-view object where the user ended the touch. In this case it's also a collectionView.
    ///   - velocity: The velocity of the scroll view (in points) at the moment the touch was released.
    ///   - targetContentOffset: The expected offset when the scrolling action decelerates to a stop.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offSet = targetContentOffset.pointee
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        self.currentSelectedAvatarIndex = Int(roundedIndex)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        offSet = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offSet
    }
    
    /// Calculates AvatarCell alpha on every scroll.
    /// - Parameter scrollView: <#scrollView description#>
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateAvatarCellAlpha(scrollView: scrollView)
    }
}

//MARK: - TextField
extension LoginNoRegisteredViewController:  UITextFieldDelegate {
    
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
            
            DispatchQueue.main.async {
                self.currentSelectedAvatarIndex = returningNotRegisteredPlayer.avatarIndex!
                self.collectionView.scrollToItem(at: IndexPath(item: returningNotRegisteredPlayer.avatarIndex!, section: 0), at: .centeredHorizontally, animated: true)
            }
            
        }
    }
}


