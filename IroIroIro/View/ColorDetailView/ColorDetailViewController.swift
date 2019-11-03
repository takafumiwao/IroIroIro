//
//  ColorDetailViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/20.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import LINEActivity

class ColorDetailViewController: UIViewController {
    
    var color:Color?
    var colorArray:[[String: String]]?
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var rgbLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hsvLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height*3/7)
        colorName.frame = CGRect(x: view.frame.origin.x, y: imageview.frame.origin.y + imageview.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // colorName.center.x = imageView.center.x
        rgbLabel.frame = CGRect(x: view.frame.origin.x, y: colorName.frame.origin.y + colorName.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // hexLabel.center.x = imageView.center.x
        hsvLabel.frame = CGRect(x: view.frame.origin.x, y: rgbLabel.frame.origin.y + rgbLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // rgbLabel.center.x = imageView.center.x
        hexLabel.frame = CGRect(x: view.frame.origin.x, y: hsvLabel.frame.origin.y + hsvLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        hsvLabel.center.x = imageview.center.x
        
        // Do any additional setup after loading the view.
        let colorR = Int((color?.colorR)!)
        let colorG = Int((color?.colorG)!)
        let colorB = Int((color?.colorB)!)
        let hsv = color?.changeHSV(r: (color?.colorR)!, g: (color?.colorG)!, b: (color?.colorB)!)
        imageview.layer.borderWidth = 1.0
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.backgroundColor = UIColor(red: CGFloat(colorR!)/255, green: CGFloat(colorG!)/255, blue: CGFloat(colorB!)/255, alpha: 1.0)
        colorName.text = color?.colorName
        rgbLabel.text = "R:\(String(describing: colorR!)) G:\(String(describing: colorG!)) B:\(String(describing: colorB!))"
        hsvLabel.text = "H:\(String(describing: (Int(hsv!.hue)))) S:\(String(describing: (Int(hsv!.saturation)))) V:\(String(describing: (Int(hsv!.value))))"
        let hex = color?.changeHEX(r: color!.colorR!, g: color!.colorG!, b: color!.colorB!)
        hexLabel.text = "HEX:#\(hex!)"
        
    }
    
    
    @IBAction func activity(_ sender: Any) {
        //共有する項目
        let shareRGB = "\(rgbLabel.text!)\n\(hsvLabel.text! )\n:\(hexLabel.text!)"
           
               //LINEを追加する
               let LineKit = LINEActivity()
               let myApplicationActivities = [LineKit]
               
               let activityItems = [shareRGB]
               
               //初期化処理
               let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: myApplicationActivities)
               
               //使用しないアクティビティタイプ
               let excludedActivityTypes = [
                   UIActivity.ActivityType.postToFacebook,
                   UIActivity.ActivityType.saveToCameraRoll
               ]
               
               activityVC.excludedActivityTypes = excludedActivityTypes
               
               self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func favorite(_ sender: Any) {
        colorArray = UserDefaults.standard.array(forKey: "color") as? [[String:String]]
        
        if colorArray == nil {
            colorArray = [[String: String]]()
        }
        // userDefaultに値の保存
        let dic = ["name":(color?.colorName)!,"r":(color!.colorR)!,"g":(color!.colorG)!,"b":(color!.colorB)!]
        colorArray!.append(dic)
        UserDefaults.standard.set(colorArray!, forKey: "color")
        // alertcontrollerインスタンス作成
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "お気に入りに登録しました", style: .default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert,animated: true,completion: nil)
    }
    
}
