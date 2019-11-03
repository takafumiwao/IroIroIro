//
//  FavoriteDetailViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/20.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import LINEActivity

class FavoriteDetailViewController: UIViewController {
    
    var colorArray:[String: String]?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var rgbLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hsvLabel: UILabel!
    var color = Color(name: "test", r: "test", g: "test", b: "test")
    var st: String?
    var image: UIImageView?
    var array:[String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        colorName.text = array!["name"]!
        rgbLabel.text = "R:\(array!["r"]!)G:\(array!["g"]!)B:\(array!["b"]!)"
        let r = Int(array!["r"]!)
        let g = Int(array!["g"]!)
        let b = Int(array!["b"]!)
        imageView.backgroundColor = UIColor(red: CGFloat(r!)/255, green: CGFloat(g!)/255, blue: CGFloat(b!)/255, alpha: 1.0)
//        imageView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height*3/7)
//        colorName.frame = CGRect(x: view.frame.origin.x, y: imageView.frame.origin.y + imageView.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
////        colorName.center.x = imageView.center.x
//        rgbLabel.frame = CGRect(x: view.frame.origin.x, y: colorName.frame.origin.y + colorName.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
////        rgbLabel.center.x = imageView.center.x
//        hexLabel.frame = CGRect(x: view.frame.origin.x, y: rgbLabel.frame.origin.y + rgbLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
////        hexLabel.center.x = imageView.center.x
//        hsvLabel.frame = CGRect(x: view.frame.origin.x, y: hexLabel.frame.origin.y + hexLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
//        hsvLabel.center.x = imageView.center.x
        
        imageView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height*3/7)
        colorName.frame = CGRect(x: view.frame.origin.x, y: imageView.frame.origin.y + imageView.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // colorName.center.x = imageView.center.x
        rgbLabel.frame = CGRect(x: view.frame.origin.x, y: colorName.frame.origin.y + colorName.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // hexLabel.center.x = imageView.center.x
        hsvLabel.frame = CGRect(x: view.frame.origin.x, y: rgbLabel.frame.origin.y + rgbLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        // rgbLabel.center.x = imageView.center.x
        hexLabel.frame = CGRect(x: view.frame.origin.x, y: hsvLabel.frame.origin.y + hsvLabel.frame.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        hsvLabel.center.x = imageView.center.x
        
        // Do any additional setup after loading the view.
//        let colorR = Int((colorArray!["r"])!)
//        let colorG = Int((colorArray!["g"])!)
//        let colorB = Int((colorArray!["b"])!)
//        let hsv = Color.changeHSV(r: (colorArray!["r"])!, g: (colorArray!["g"])!, b: (colorArray!["b"])!)

        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.backgroundColor = UIColor(red: CGFloat(colorR!), green: CGFloat(colorG!), blue: CGFloat(colorB!), alpha: 1.0)
//        colorName.text = colorArray!["name"]
//        rgbLabel.text = "R: \(String(describing: colorR!)) G: \(String(describing: colorG!)) B: \(String(describing: colorB!))"
//        hsvLabel.text = "H: \(String(describing: (Int(hsv!.hue)))) S: \(String(describing: (Int(hsv!.saturation)))) V: \(String(describing: (Int(hsv!.value))))"
//        let hex = color?.changeHEX(r: color!.colorR!, g: color!.colorG!, b: color!.colorB!)
//        hexLabel.text = "HEX: \(hex!)"
        let hsv = color.changeHSV(r: String(r!), g: String(g!), b: String(b!))
        rgbLabel.text = "R:\(String(describing: r!)) G:\(String(describing: g!)) B:\(String(describing: b!))"
        hsvLabel.text = "H:\(String(describing: (Int(hsv.hue)))) S:\(String(describing: (Int(hsv.saturation)))) V:\(String(describing: (Int(hsv.value))))"
        let hex = color.changeHEX(r: String(r!), g: String(g!), b: String(b!))
        hexLabel.text = "HEX:#\(hex)"
       
    }
    
    @IBAction func tapShare(_ sender: Any) {
        //共有する項目
        let shareRGB = "\(rgbLabel.text!)\n\(hsvLabel.text! )\n\(hexLabel.text!)"
           
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
    
}
