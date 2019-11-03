//
//  ColorNumberViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/26.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import Firebase

class ColorNumberViewController: UIViewController {
    
    var rColor: Int?
    var gColor: Int?
    var bColor: Int?
    var aColor: CGFloat?
    var color = Color(name: "test", r: "test", g: "test", b: "test")
    var activityIndicator = UIActivityIndicatorView()
    var colorArray : [[String:String]]?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rgbLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hsvLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height*3/7)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = UIColor(red: CGFloat(rColor!)/255, green: CGFloat(gColor!)/255, blue: CGFloat(bColor!)/255, alpha: 1.0)
        rgbLabel.frame = CGRect(x: view.frame.origin.x, y: imageView.frame.origin.y + imageView.bounds.height + 25.0, width: view.frame.width, height: view.frame.height/11)
        hexLabel.frame = CGRect(x: view.frame.origin.x, y: rgbLabel.frame.origin.y + rgbLabel.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        hsvLabel.frame = CGRect(x: view.frame.origin.x, y: hexLabel.frame.origin.y + hexLabel.bounds.height + 5.0, width: view.frame.width, height: view.frame.height/11)
        let hsv = color.changeHSV(r: (String(rColor!)), g: (String(gColor!)), b: (String(bColor!)))
//        rgbLabel.text = "R:\(String(rColor!))G:\(String(gColor!))B:\(String(bColor!))"
        rgbLabel.text = "R:\(String(describing: rColor!)) G:\(String(describing: gColor!)) B:\(String(describing: bColor!))"
        print(hsv)
        hsvLabel.text = "H:\(String(describing: (Int(hsv.hue)))) S:\(String(describing: (Int(hsv.saturation)))) V:\(String(describing: (Int(hsv.value))))"
        let hex = color.changeHEX(r: String(rColor!), g: String(gColor!), b: String(bColor!))
        hexLabel.text = "HEX:#\(hex)"
    }
    

    
    @IBAction func tapSave(_ sender: Any) {
        // tapしたらアラートを出す
        let ac = UIAlertController(title: "登録", message: "名前をつけましょう！", preferredStyle: .alert)
       // textField
        ac.addTextField { (text) in
            text.placeholder = "名前をつけてください"
        }
        // ok
        let okaction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let textFields = ac.textFields else { return }
            self.activityIndicator.style = UIActivityIndicatorView.Style.large
            self.activityIndicator.center.x = self.view.center.x
            self.activityIndicator.center.y = self.view.center.y
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            for textField in textFields {
                // Firebaseに登録する
                 let db = Firestore.firestore()
                let name = textField.text
                let colorData = ["name": name!, "colorR": String(describing: self.rColor!), "colorG": String(describing: self.gColor!), "colorB": String(describing: self.bColor!)]
                 db.collection("Color").document().setData(colorData) { (eroor) in
                     if let err = eroor {
                         // 失敗
                         self.activityIndicator.stopAnimating()
                        let ac = UIAlertController(title: "登録に失敗しました", message: "\(err)", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        ac.addAction(okButton)
                        self.present(ac, animated: true, completion: nil)
                     } else {
                         // 成功
                         self.activityIndicator.stopAnimating()
                        let ac = UIAlertController(title: "登録しました", message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                            ac.addAction(okButton)
                        self.colorArray = UserDefaults.standard.array(forKey: "color") as? [[String:String]]
                        
                        if self.colorArray == nil {
                            self.colorArray = [[String: String]]()
                        }
                        // userDefaultに値の保存
                        let dic = ["name":name! ,"r":String(describing: self.rColor!),"g":String(describing: self.gColor!),"b":String(describing: self.bColor!)]
                        self.colorArray!.append(dic)
                        UserDefaults.standard.set(self.colorArray!, forKey: "color")
                        self.present(ac, animated: true, completion: nil)
                     }
                 }
            }
        }
        ac.addAction(okaction)
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelaction)
        present(ac, animated: true, completion: nil)
        
    }
    
}
