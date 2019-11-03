//
//  ViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/14.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    // 色を格納する配列
    var colorArray = [Color]()
    var activityIndicator = UIActivityIndicatorView()
    // firestoreのdb
    private let db = Firestore.firestore()
    
    // safearea
    var topSafeAreaHeight: CGFloat = 0
    var BottomSafeAreaHeigt: CGFloat = 0
    
    // cellのimageViewとlabel
    enum Tag: Int {
        case image = 2
        case label = 1
    }
    // cellのレイアウト用
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let itemPerRow: CGFloat = 3
    private let flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center.x = view.center.x
        activityIndicator.center.y = view.center.y - (navigationController?.navigationBar.frame.height)!
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Firebaseからデータを読み込む
        reloadFirebase()
        
        
        // delegate設定
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            topSafeAreaHeight = self.view.safeAreaInsets.top
            BottomSafeAreaHeigt = self.view.safeAreaInsets.bottom

            collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - topSafeAreaHeight - BottomSafeAreaHeigt - toolBar.frame.height)
            
            // cellの大きさ
            flowLayout.itemSize = CGSize(width: view.frame.width / 3, height: collectionView.frame.size.height / 3)
            print(flowLayout.itemSize)
            flowLayout.sectionInset = sectionInsets
            flowLayout.minimumInteritemSpacing = 0.0
            flowLayout.minimumLineSpacing = 0.0
            // collectionViewに反映
            collectionView.collectionViewLayout = flowLayout
            collectionView.backgroundColor = UIColor.black
            
           
        }
    }

    
    // CameraViewControllerに遷移する
    @IBAction func goCamera(_ sender: Any) {
//        performSegue(withIdentifier: "camera", sender: nil)
        let sourceType = UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPiceker = UIImagePickerController()
            cameraPiceker.sourceType = sourceType
            cameraPiceker.delegate = self
            cameraPiceker.allowsEditing = true
            present(cameraPiceker, animated: true, completion: nil)
        } else {
            print("エラー")
        }
    }
    
    // FavoriteViewControllerに遷移する
    @IBAction func goFavorite(_ sender: Any) {
        performSegue(withIdentifier: "favorite", sender: nil)
    }
    
    // sectionnの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // cellの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(colorArray.count)
        return colorArray.count
       }
    
    // cellの構成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
//        cell.layer.borderWidth = 1.0
        let imageView = cell.contentView.viewWithTag(Tag.image.rawValue) as! UIImageView
        let label = cell.contentView.viewWithTag(Tag.label.rawValue) as! UILabel
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(label)
        cell.backgroundColor = UIColor.black
        let color = colorArray[indexPath.row]
        let colorR = Int(color.colorR!)
        let colorG = Int(color.colorG!)
        let colorB = Int(color.colorB!)
        let name = color.colorName!
        imageView.backgroundColor = UIColor(red: CGFloat(colorR!)/255, green: CGFloat(colorG!)/255, blue: CGFloat(colorB!)/255, alpha: 1.0)
        imageView.frame.size = CGSize(width: cell.bounds.width*2/3, height: cell.bounds.width*2/3)
        imageView.center.x = cell.bounds.width/2
        imageView.center.y = cell.bounds.height/2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        print("\(imageView.center)")
        label.frame = CGRect(x: imageView.frame.width/2, y: imageView.frame.height + 10, width: cell.frame.width, height: 20)
        label.text = name
        label.textColor = .white
        label.center.x = cell.bounds.width/2
        label.center.y = imageView.frame.origin.y + imageView.frame.height + 30.0
        return cell
       }
   
    // cellがタッチされた
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    // 遷移時の値渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
        let nxVC = segue.destination as! ColorDetailViewController
        let indexPath = sender as! IndexPath
        nxVC.color = self.colorArray[indexPath.row]
        } else if segue.identifier == "imageView" {
            let nxVC = segue.destination as! CameraImageViewController
            let imageView = sender as! UIImage
//            nxVC.image = imageView
        }
    }
    

    
    // firebaseから値を取得
    func reloadFirebase() {
        
        // firebaseからデータを取得する
        db.collection("Color").getDocuments { (snapShot, error) in
            if let err = error {
                print("Error getting documents \(err)")
            } else {
                for document in snapShot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    // 中身を取り出す
                    let data = document.data()
                    let name = data["name"] as! String
                    let colorR = data["colorR"] as! String
                    let colorG = data["colorG"] as! String
                    let colorB = data["colorB"] as! String
                    // Colorインスタンス作成
                    let color = Color(name: name, r: colorR, g: colorG, b: colorB)
                    // 配列に追加
                    self.colorArray.append(color)
                }
            }
            // collectionView更新
            self.collectionView.reloadData()
            // activityIndicatorをとめる
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // firebaseからデータを取得する
        db.collection("Color").getDocuments { (snapShot, error) in
            if let err = error {
                print("Error getting documents \(err)")
            } else {
                self.colorArray.removeAll()
                for document in snapShot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    // 中身を取り出す
                    let data = document.data()
                    let name = data["name"] as! String
                    let colorR = data["colorR"] as! String
                    let colorG = data["colorG"] as! String
                    let colorB = data["colorB"] as! String
                    // Colorインスタンス作成
                    let color = Color(name: name, r: colorR, g: colorG, b: colorB)
                    
                    // 配列に追加
                    self.colorArray.append(color)
                }
            }
            // collectionView更新
            self.collectionView.reloadData()
            // activityIndicatorをとめる
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
        
    }
    
   // 撮影が鑑賞した時に呼ばれる
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pikeedImage = info[.originalImage] as? UIImage {
//           createStoryboard
          performSegue(withIdentifier: "imageView", sender: nil)
          print("\(pikeedImage)")
          }
      }
    
    
    
   
    
    
}

