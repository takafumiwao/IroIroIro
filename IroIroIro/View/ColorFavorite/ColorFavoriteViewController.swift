//
//  ColorFavoriteViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/20.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

class ColorFavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var colorArray = [[String: String]]()
    var topSafeAreaHeight:CGFloat = 0
    var bottomSafeAreaHeight:CGFloat = 0
    var string: String?
    var imageView: UIImageView?
    var array:[String:String]?
    enum Tag:Int {
        case image = 2
        case label = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.backgroundColor = .black
        let array = UserDefaults.standard.array(forKey: "color") as? [[String: String]]
        if let array = array {
            colorArray = array
            tableview.reloadData()
            print("colorArray.element \(colorArray)")
            
        }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("colorArray\(colorArray.count)")
        return colorArray.count
        
       }
       
    // cellの構成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableview.rowHeight = CGFloat(tableview.frame.height/5)
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height/5)
        let imageView = cell.contentView.viewWithTag(Tag.image.rawValue) as! UIImageView
        let label = cell.contentView.viewWithTag(Tag.label.rawValue) as! UILabel
        let colorData = colorArray[indexPath.row]
        let name = colorData["name"]!
        let r = Int(colorData["r"]!)!
        let g = Int(colorData["g"]!)!
        let b = Int(colorData["b"]!)!
        imageView.backgroundColor = UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        imageView.frame = CGRect(x: cell.bounds.origin.x + 10, y: cell.bounds.origin.y, width: tableView.rowHeight*2/3, height: tableView.rowHeight*2/3)
        print(imageView.frame)
        imageView.center.y = cell.frame.height/2
        print(cell.frame.height)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.center.x = cell.bounds.width*3/16
//        imageView.center.y = cell.bounds.height/2
//        label.frame.size = CGSize(width: cell.frame.width - imageView.frame.origin.x - imageView.frame.width - 10, height: cell.frame.height/3)
        label.frame = CGRect(x: imageView.frame.origin.x + imageView.bounds.width + 15.0, y: imageView.center.y*2/3, width: cell.frame.width - imageView.frame.origin.x - imageView.frame.width - 10, height: cell.frame.height/3)
        label.text = name
        label.textColor = .white
        
        return cell
       }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
         array = colorArray[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritedetail" {
        let nxVC = segue.destination as! FavoriteDetailViewController
            nxVC.array = array
            
            
            if let indexPathForSelectedRow = tableview.indexPathForSelectedRow {
                tableview.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            colorArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.setValue(colorArray, forKey: "color")
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//    
    
    
}
