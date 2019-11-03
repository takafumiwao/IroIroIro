//
//  CameraImageViewController.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/26.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

class CameraImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    //表示されている画像のタップ座標用変数
    var tapPoint = CGPoint(x: 0, y: 0)
    var originalTappoint = CGPoint(x: 0, y: 0)

    var image = UIImage()
    var imageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.frame = CGRect(origin: .zero, size: view.bounds.size)
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(imageView)
        
        
        //画像の縦横サイズ比率を変えずに制約を合わせる
        imageView.contentMode = UIView.ContentMode.scaleToFill
        
//        scrollView.contentSize = imageView.bounds.size
//        scrollView.addSubview(imageView)
//        view.addSubview(scrollView)
        
        // ダブルタップ
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(CameraImageViewController.doubleTap(gesture:)))
        // シングルタップ
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CameraImageViewController.getImageRGB(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTap)
        imageView.addGestureRecognizer(singleTap)
        
        
//        let imageSize: CGSize
//        //UIimageの向きによって縦横を変える
//        switch image.imageOrientation.rawValue {
//        case 3:
//            imageSize = CGSize(width: image.size.height, height: image.size.width)
//        default:
//            imageSize = CGSize(width: image.size.width, height: image.size.height)
//        }
        
        //uiimageViewのサイズを表示されている画像のサイズに合わせる
//        if imageSize.width > imageSize.height {
//            imageView.frame.size.height = imageSize.height/imageSize.width * imageView.frame.width
//
//        } else {
//            imageView.frame.size.width = imageSize.width/imageSize.height * imageView.frame.height
//        }
//
//        imageView.center = self.view.center
//
//        self.view.addSubview(imageView)
//        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("zoomend")
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("start zoom")
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        if(self.scrollView.zoomScale < 3){
            let newScale: CGFloat = self.scrollView.zoomScale*3
            let zoomRect: CGRect = self.zoomForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        }else{
            self.scrollView.setZoomScale(1.0, animated: true)
            
        }
    }
    
    func zoomForScale(scale:CGFloat, center: CGPoint) -> CGRect {
        var zoomRect : CGRect = CGRect()
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width / scale
        
        zoomRect.origin.x = center.x - zoomRect.size.width/2.0
        zoomRect.origin.y = center.y - zoomRect.size.height/2.0
        return zoomRect
    }
    
    
    
    @objc func getImageRGB(_ sender: UITapGestureRecognizer) {
        guard imageView.image != nil else {return}
        print("tap")
            //タップした座標の取得
            tapPoint = sender.location(in: scrollView)
            //向きによって元の画像のタップ座標を変える(右に90°回転している場合)
        switch image.imageOrientation.rawValue {
            case 3:
                originalTappoint.x = image.size.height/imageView.frame.height * tapPoint.y
                originalTappoint.y = image.size.width - (image.size.width/imageView.frame.width * tapPoint.x)
                print("3")
                
            default:
                tapPoint.x = image.size.width/imageView.frame.width * tapPoint.x
                tapPoint.y = image.size.height/imageView.frame.height * tapPoint.y
                print("default")
            }
           
    
            let cgImage = imageView.image?.cgImage!
            let pixelData = cgImage?.dataProvider!.data
            let data: UnsafePointer = CFDataGetBytePtr(pixelData)
            //1ピクセルのバイト数
            let bytesPerPixel = (cgImage?.bitsPerPixel)! / 8
            //1ラインのバイト数
            let bytesPerRow = (cgImage?.bytesPerRow)!
        
            //タップした位置の座標にあたるアドレスを算出
            let pixelAd: Int = Int(originalTappoint.y) * bytesPerRow + Int(originalTappoint.x) * bytesPerPixel
            print(pixelAd)
            //それぞれのRGBAをとる
            let r = Int( CGFloat(data[pixelAd]))///CGFloat(255.0)*100)) / 100
            let g = Int( CGFloat(data[pixelAd+1]))///CGFloat(255.0)*100)) / 100
            let b = Int( CGFloat(data[pixelAd+2]))///CGFloat(255.0)*100)) / 100
            let a = CGFloat(Int( CGFloat(data[pixelAd+3])/CGFloat(255.0)*100)) / 100
            print(r,g,b,a)
//            let intr = r
//            let intg = g
//            let intb = b
            
            performSegue(withIdentifier: "colorNumber", sender: ["r": r, "g": g, "b": b, "a": a])
            
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorNumber" {
            let nxVC = segue.destination as! ColorNumberViewController
            let dic = sender as! [String: Any]
            let r = dic["r"] as! Int
            let g = dic["g"] as! Int
            let b = dic["b"] as! Int
            let a = dic["a"] as! CGFloat
            
            nxVC.rColor = r
            nxVC.gColor = g
            nxVC.bColor = b
            nxVC.aColor = a
         }
    }

}
