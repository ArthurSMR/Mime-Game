//
//  LoginNoRegisteredViewController.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 20/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class LoginNoRegisteredViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var avaliableAvatars: [Avatar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.avaliableAvatars = createAvaliableAvatarsArray()
        
        self.setupAvatarsScrollView(avatars: avaliableAvatars)
        
        pageControl.numberOfPages = avaliableAvatars.count
        pageControl.currentPage = 0
        
        containerView.bringSubviewToFront(pageControl)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setupAvatarsScrollView(avatars: avaliableAvatars)
    }
    
    func createAvaliableAvatarsArray() -> [Avatar] {
        var avatars: [Avatar] = []
        let imageURLArray = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "test-no-register-avatars")! as [NSURL]
        
        for url in imageURLArray {
            let avatarIImage = UIImage(contentsOfFile: url.path!)
            
            let avatar = Bundle.main.loadNibNamed("Avatar", owner: self, options: nil)?.first as! Avatar
            avatar.avatarImageView.image = avatarIImage
            avatar.avatarImageView.contentMode = .scaleAspectFit
            
            avatars.append(avatar)
        }
        
        return avatars
    }
    
    func setupAvatarsScrollView(avatars: [Avatar]) {
        //        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(avatars.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< avatars.count {
            avatars[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(avatars[i])
        }
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/containerView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        var currentAvatar: Avatar
        var nextAvatar: Avatar?
        
        let divisions = avaliableAvatars.count - 1
        let step = 1/divisions
        
        
        for i in 0...divisions-1{
            if percentOffset.x > CGFloat(i)*CGFloat(step) && percentOffset.x <= CGFloat(i+1) * CGFloat(step){
                
                let factor = (i+1)*step
                currentAvatar = avaliableAvatars[i]
                nextAvatar = avaliableAvatars[i+1]
                
                currentAvatar.avatarImageView.transform = CGAffineTransform(scaleX: (CGFloat(factor)-percentOffset.x)/CGFloat(factor), y: (CGFloat(factor)-percentOffset.x)/CGFloat(factor))
                nextAvatar?.avatarImageView.transform = CGAffineTransform(scaleX: percentOffset.x/CGFloat(factor), y: percentOffset.x/CGFloat(factor))
                
                
            }
        }
    }
        



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
}
