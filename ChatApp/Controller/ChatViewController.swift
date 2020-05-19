//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 及田　一樹 on 2020/05/19.
//  Copyright © 2020 oita kazuki. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtom: UIButton!
    
    //スクリーンのサイズを取得
    let screenSize = UIScreen.main.bounds.size
    
    var chatArray = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier:"Cell")
        //セルが可変式
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 75
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //firebaseからデータをfetchしてくる
        fetchChatData()
        
        //テーブルビューの分けるラインをなくす
        tableView.separatorStyle = .none
        
        
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        messageTextField.frame.origin.y = screenSize.height - keyboardHeight - messageTextField.frame.height
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        
        messageTextField.frame.origin.y = screenSize.height - messageTextField.frame.height
        
        guard
            let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? TimeInterval
            else{return}
        
        UIView.animate(withDuration: duration) {
            
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        messageTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //メッセージの数
        return chatArray.count
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.messasgeLabel.text = chatArray[indexPath.row].message
        cell.userNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userNameLabel.text == Auth.auth().currentUser?.email as! String{
            
            cell.messasgeLabel.backgroundColor = UIColor.flatGreen()
            cell.messasgeLabel.layer.cornerRadius = 20.0
            cell.messasgeLabel.layer.masksToBounds = true
            
        }else{
            
            cell.messasgeLabel.backgroundColor = UIColor.flatBlue()
            cell.messasgeLabel.layer.cornerRadius = 20.0
            cell.messasgeLabel.layer.masksToBounds = true
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/10
        
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButtom.isEnabled = false
        
        if messageTextField.text!.count > 15{
            
            print("15文字以上です")
            return
            
        }
        
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型(dictionary)で送信する
        let messageInfo = ["sender":Auth.auth().currentUser?.email,"message":messageTextField.text!]
        
        //chatBDに入れる
        chatDB.childByAutoId().setValue(messageInfo) { (error,result) in
            
            if error != nil{
                
                print(error)
                
            }else{
                
                print("送信が完了しました！！")
                self.messageTextField.isEnabled = true
                self.sendButtom.isEnabled = true
                self.messageTextField.text = ""
                
            }
        }
        
    }
    
    func fetchChatData(){
        
        //どこから引っ張ってくるのか
        let fetchDataRef = Database.database().reference().child("chats")
        
        //新しく更新があった時だけ取得したい
        fetchDataRef.observe(.childAdded){ (snapShot) in
            
            let snapShotData = snapShot.value as! AnyObject
            let text = snapShotData.value(forKey: "message")
            let sender = snapShotData.value(forKey: "sender")
            
            let message = Message()
            message.message = text as! String
            message.sender = sender as! String
            self.chatArray.append(message)
            self.tableView.reloadData()
            
            
        
        }
        
    }
    
}
