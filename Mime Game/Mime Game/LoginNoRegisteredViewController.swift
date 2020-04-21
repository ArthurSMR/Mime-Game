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
    
    var avaliableAvatars: [Avatar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaliableAvatars = createAvaliableAvatarsArray()

        // Do any additional setup after loading the view.
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
            avatars.append(avatar)
        }
        
        return avatars
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
