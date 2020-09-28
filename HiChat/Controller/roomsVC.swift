//
//  roomsVC.swift
//  HiChat
//
//  Created by Ahmed Nasr on 9/27/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class roomsVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomNameTxt: UITextField!
    var roomModelArray: [roomModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        observeData()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            toHomeScreen()
        }
    }
    
    
    @IBAction func createRoomOnClick(_ sender: Any) {
        
        let ref = Database.database().reference()
        let room = ref.child("Rooms").childByAutoId()
        
        let roomName = roomNameTxt.text
        
        guard roomName != nil , roomName?.isEmpty == false else {
            return
        }
        
        room.child("roomName").setValue(roomName) { (error, ref) in
            
            if error == nil {
                
                self.roomNameTxt.text = ""
            }
        }
    }
    
    
    func observeData(){
        
        let ref = Database.database().reference()
        
        ref.child("Rooms").observe(.childAdded) { (snapShot) in
            
            if  let snapshotReal = snapShot.value as? [String: Any] {
                if let room = snapshotReal["roomName"] as? String {
                    let roomName = roomModel.init(roomId: snapShot.key, roomName: room)
                    self.roomModelArray.append(roomName)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedroom = self.roomModelArray[indexPath.row]
        
        let openChatView = self.storyboard?.instantiateViewController(identifier: "chatView") as! ChatVC
        openChatView.room = selectedroom
        self.navigationController?.pushViewController(openChatView, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        cell.textLabel!.text = roomModelArray[indexPath.row].roomName
        return cell
    }
    
    
    
    @IBAction func logoutOnClick(_ sender: UIBarButtonItem) {
        
       try! Auth.auth().signOut()
        toHomeScreen()
    }
    
    func toHomeScreen(){
        
        let home = self.storyboard?.instantiateViewController(identifier: "homePage")
        self.present(home! , animated:  true , completion: nil)
    }
}
