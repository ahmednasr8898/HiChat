//
//  ChatVC.swift
//  HiChat
//
//  Created by Ahmed Nasr on 9/27/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//
import UIKit
import Firebase
class ChatVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var messegeTxt: UITextField!
    var room: roomModel?
    @IBOutlet weak var tableChatView: UITableView!
    var arrOfMessege: [messegeModel] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableChatView.delegate = self
        tableChatView.dataSource = self
        observeMessegeData()
        tableChatView.separatorEffect = .none // to hidden line between cell
        tableChatView.allowsSelection = false // to stop effect when insed cell
        title = room?.roomName
    }
    @IBAction func sendMessegeOnClick(_ sender: Any) {
        let messege = messegeTxt.text
        guard messege != nil , messege?.isEmpty == false , let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        let user = ref.child("Users").child(userId)
        user.child("userName").observeSingleEvent(of: .value) { (snapshot) in
            if let username = snapshot.value as? String {
                if let roomId = self.room?.roomId , let senderId = Auth.auth().currentUser?.uid {
                    let messegeArray: [String: Any] = ["SenderName" : username , "text" : messege , "SenderId": senderId ]
                    ref.child("Rooms").child(roomId).child("Messeges").childByAutoId().setValue(messegeArray) { (error, ref) in
                        if error == nil {
                            self.messegeTxt.text = ""
                        }
                    }
                }
            }
        }
    }
    func observeMessegeData(){
        guard let roomId = room?.roomId else { return }
            let ref = Database.database().reference()
            ref.child("Rooms").child(roomId).child("Messeges").observe(.childAdded) { (snapshot) in
                if let messegeArray = snapshot.value as? [String: Any] {
                    guard let username = messegeArray["SenderName"] as? String , let text = messegeArray["text"] as? String , let senderId = messegeArray["SenderId"] as? String else { return }
                    let messegeInfo = messegeModel.init(messegeKey: snapshot.key, senderMessege: username, textMessege: text, senderID: senderId)
                        self.arrOfMessege.append(messegeInfo)
                        self.tableChatView.reloadData()
                    }
                }
            }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        cell.senderMessegeLbl.text = self.arrOfMessege[indexPath.row].senderMessege
        cell.messgeTextView.text = self.arrOfMessege[indexPath.row].textMessege
        if arrOfMessege[indexPath.row].senderID == Auth.auth().currentUser?.uid {
            cell.bubbleType(type: .outgoing)
        }else{
            cell.bubbleType(type: .incoming)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfMessege.count
    }
}
