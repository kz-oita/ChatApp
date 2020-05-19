 //
//  RegisterViewController.swift
//  ChatApp
//
//  Created by 及田　一樹 on 2020/05/19.
//  Copyright © 2020 oita kazuki. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emalTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let animationView = AnimationView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func registerNewUser(_ sender: Any) {
        //アニメーションのスタート
        startAnimation()
        
        //firebaseにユーザーを登録する
        Auth.auth().createUser(withEmail: emalTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            
            
            
            if error != nil{
                
                print(error)
            
            }else{
                
                print("ユーザー登録が完了しました！")
                
                //アニメーションのストップ
                self.stopAnimation()
                
                //チャット画面に遷移
                self.performSegue(withIdentifier: "chat", sender: nil)
                
            }
        }
    }
    
    func startAnimation(){
        
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/1.5)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        view.addSubview(animationView)
        
    }
    
    func stopAnimation(){
        
        animationView.removeFromSuperview()
    }
}
