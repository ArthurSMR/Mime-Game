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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
//    func setupScrollView() {
//        self.scrollView.frame =
//    }

    func createAvaliableAvatarsArray() -> [Avatar]? {
        guard let _resourcePath = Bundle.main.resourcePath else{
            return nil
        }
        
        var avatars: [Avatar]? = nil
        
        do{
            if let url = NSURL(string: _resourcePath)?.appendingPathComponent("test-no-register-avatars"){
                let resourcesContent = try FileManager().contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

                for imageUrl in resourcesContent {
                    let imageName = imageUrl.lastPathComponent
                    let avatarI = Bundle.main.loadNibNamed("Avatar", owner: self, options: nil)?.first as! Avatar
                    avatarI.avatarImageView.image = UIImage(named: imageName)
                    
                    guard avatars != nil else {
                        avatars = []
                        avatars?.append(avatarI)
                        return avatars
                    }
                    
                    avatars?.append(avatarI)
                }
            }
        }catch let error{
            print(error.localizedDescription)
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
