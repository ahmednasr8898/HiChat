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
        createNewRoom()
    }
    func observeData(){
        let ref = Database.database().reference()
        ref.child("Rooms").observe(.childAdded) { (snapShot) in
            if  let snapshotReal = snapShot.value as? [String: Any] {
                let  roomPassword = snapshotReal["roomPassword"] as? String
                if let roomName = snapshotReal["roomName"] as? String, let roomOwner = snapshotReal["roomOwner"] as? String {
                    let roomName = roomModel(roomId: snapShot.key, roomName: roomName, roomOwner: roomOwner, roomPassword: roomPassword ?? "")
                    self.roomModelArray.append(roomName)
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if roomModelArray[indexPath.row].roomPassword != "" {
            //room private
            showAlert(title: "enter password fot join this room", messege: "", placeholderTextField: "put password") { (password, isCancelDialog) in
                if isCancelDialog{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    if self.roomModelArray[indexPath.row].roomPassword == password{
                        self.goToRoomVC(indexPathRow: indexPath.row)
                    }else{
                        print("this password is worng!!!")
                    }
                }
            }
        }else{
            self.goToRoomVC(indexPathRow: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! roomCell
        cell.roomNameLabel.text = roomModelArray[indexPath.row].roomName
        cell.roomOwnerLabel.text = roomModelArray[indexPath.row].roomOwner
        if roomModelArray[indexPath.row].roomPassword == "" {
            cell.roomStatusImageView.image = UIImage(systemName: "lock.open.fill")
        }else{
            cell.roomStatusImageView.image = UIImage(systemName: "lock.fill")
        }
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
extension roomsVC{
    func getCurrentUserName(complation: @escaping(String)->Void){
        guard let currentUser = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: .value) { (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let userName = value["userName"] as? String else {return}
                complation(userName)
            }
        }
    }
}
extension roomsVC{
    func showAlert(title: String?, messege: String?,placeholderTextField: String?, complation: @escaping (String?,Bool)->Void){
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        alert.addTextField { (txt) in
            txt.placeholder = placeholderTextField
        }
        let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
            //handel
            guard let txt = alert.textFields?[0].text, !txt.isEmpty else {
                print("must put passowrd to room")
                return
            }
            complation(txt,false)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            complation(nil,true)
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension roomsVC{
    func goToRoomVC(indexPathRow: Int){
        let selectedroom = self.roomModelArray[indexPathRow]
        let openChatView = self.storyboard?.instantiateViewController(identifier: "chatView") as! ChatVC
        openChatView.room = selectedroom
        self.navigationController?.pushViewController(openChatView, animated: true)
    }
}
extension roomsVC{
    func createNewRoom(){
        let ref = Database.database().reference()
        let room = ref.child("Rooms").childByAutoId()
        let roomName = roomNameTxt.text
        guard roomName != nil , roomName?.isEmpty == false else { return }
        self.showAlert(title: "Do you want to make your room private ", messege: "Recommended", placeholderTextField: "put password") {
            (passowrd,cancel)  in
            if cancel{
                self.getCurrentUserName { (userName) in
                    room.setValue(["roomName": roomName, "roomOwner":userName]) { (error, ref) in
                        if error == nil{
                            self.roomNameTxt.text = ""
                        }
                    }
                }
            }else{
                print("your room is private")
                self.getCurrentUserName { (userName) in
                    room.setValue(["roomName": roomName, "roomOwner":userName, "roomPassword": passowrd]) { (error, ref) in
                        if error == nil{
                            self.roomNameTxt.text = ""
                        }
                    }
                }
            }
        }
    }
}
