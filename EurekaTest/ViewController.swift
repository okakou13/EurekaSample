//
//  ViewController.swift
//  EurekaTest
//
//  Created by 岡田昂典 on 2020/04/14.
//  Copyright © 2020 Kosuke Okada. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class ViewController: FormViewController {
    
    var userImageView = UIImageView()
    var selectedImage = UIImage()
    var userNameText : String = ""
    var userIDText : String = ""
    var introductionText : String = ""
    var selectedSex : String = ""
    var selectedage = Int()
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("プロフィール画像")
            <<< ImageRow(){
                $0.title = "プロフィール画像"
                $0.sourceTypes = [.Camera,.PhotoLibrary]
                $0.clearAction = .no
            }.cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius =  (cell.accessoryView?.bounds.width)! / 2
            }.onChange({ (ImageRow) in
                self.selectedImage = ImageRow.value!
            })
        
        form +++ Section("自己紹介")
            <<< TextAreaRow("自己紹介を書いてね!!") {
                $0.placeholder = "Notes"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
                $0.value = self.introductionText
            }
            .onChange({ row in
                self.introductionText = row.value ?? "はじめまして"
            })
        
        form +++ Section("基本情報")
            
            <<< TextRow(){ row in
                row.title = "名前"
                row.placeholder = userNameText
            }.onChange{ row in
                self.userNameText = row.value ?? "userName"
            }
            
            <<< TextRow(){ row in
                row.title = "ユーザーID"
                row.placeholder = userIDText
            }.onChange{ row in
                self.userIDText = row.value ?? "userID"
            }
            
            <<< PickerInlineRow<String>("sex"){ row in
                row.title = "性別"
                row.options = ["未選択","MEN","WOMAN"]
                row.value = selectedSex
            }.onChange({ [unowned self] row in
                self.selectedSex = row.value!
            })

            <<< DateRow(){
                $0.title = "誕生日"
                let birthDay = userDefault.object(forKey: "birthDay") as? Cell<Date>.Value
                if birthDay != nil {
                $0.value = (userDefault.object(forKey: "birthDay") as! Cell<Date>.Value)
                    let age = self.getDays(date: $0.value)
                    self.selectedage = age
                }else{
                    $0.value = Date()
                }
                
            }.onChange({ (date) in
                let birth = date.value
                self.userDefault.set(birth,forKey: "birthDay")
                let age = self.getDays(date: birth)
                self.selectedage = age
            })
    }
    func getDays(date:Date?,anotherDay:Date? = nil) -> Int{
        var retInterval:Double!
        if anotherDay == nil {
            retInterval = date?.timeIntervalSinceNow
        }else{
            retInterval = date?.timeIntervalSince(anotherDay!)
        }
        let ret = Int(-(retInterval/(86400*365)))
        return ret
    }
}
