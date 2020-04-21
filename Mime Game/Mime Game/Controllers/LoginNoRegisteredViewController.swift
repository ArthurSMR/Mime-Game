    //
//  LoginNoRegisteredViewController.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 20/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class LoginNoRegisteredViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var avaliableAvatars: [Avatar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaliableAvatars = createAvaliableAvatarsArray()

        setupAvatarsScrollView(avatars: avaliableAvatars)
        
        pageControl.numberOfPages = avaliableAvatars.count
        pageControl.currentPage = 0
        
        containerView.bringSubviewToFront(pageControl)
    }
    
    
//    func setupScrollView() {
//        self.scrollView.frame =
//    }

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
