//
//  ViewController.swift
//  HiChat
//
//  Created by Ahmed Nasr on 9/26/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
class HomeVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        if (indexPath.row == 0 ){
            cell.nameTxt.isHidden = true
            cell.actionBtn.setTitle("Login", for: .normal)
            cell.sliderBtn.setTitle("Sign Up -->", for: .normal)
            cell.sliderBtn.addTarget(self, action: #selector(silderToSignin(_:)), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didActionSignIn(_:)), for: .touchUpInside)
        }
        else if (indexPath.row == 1 ){
            cell.nameTxt.isHidden = false
            cell.actionBtn.setTitle("Sign up", for: .normal)
            cell.sliderBtn.setTitle("<-- sign in", for: .normal)
            cell.sliderBtn.addTarget(self, action: #selector(silderToSignup(_:)), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didActionSignUp(_:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func silderToSignin(_ sender: UIButton){
        let index = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: index, at: [.centeredHorizontally], animated: true)
    }
    @objc func silderToSignup(_ sender: UIButton){
        let index = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: index, at: [.centeredHorizontally], animated: true)
    }
    @objc func didActionSignUp(_ sender: UIButton){
        let index = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: index) as! HomeCell
        let userName = cell.nameTxt.text
        let email = cell.emailTxt.text
        let password = cell.passwordTxt.text
        guard (email != nil) , (password != nil) else { return }
        if (userName?.isEmpty == true || email?.isEmpty == true || password?.isEmpty == true){
            displayError(messegeError: "All Fields is required")
            
        }else{
        Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                    let ref = Database.database().reference()
                    let users = ref.child("Users").child(result!.user.uid).child("userName")
                    users.setValue(userName)
                }else{
                    self.displayError(messegeError: "faild when create account")
            }
        }
    }
}
    @objc func didActionSignIn(_ sender: UIButton){
        let index = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: index) as! HomeCell
        let email = cell.emailTxt.text
        let password = cell.passwordTxt.text
        guard  email != nil , password != nil else {return }
        if (email?.isEmpty == true || password?.isEmpty == true){
            self.displayError(messegeError: "All field is requird")
        }else{
        Auth.auth().signIn(withEmail: email! , password: password!) { (result, error) in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.displayError(messegeError: "Login Faild")
            }
        }
    }
}
    func displayError(messegeError: String){
        let alert = UIAlertController(title: "Error", message: messegeError, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert , animated:  true , completion: nil)
    }    
}

