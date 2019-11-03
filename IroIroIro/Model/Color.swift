//
//  Color.swift
//  IroIroIro
//
//  Created by 岩男高史 on 2019/10/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class Color {
    // 名前
    var colorName: String?
    // RGB
    var colorR: String?
    var colorG: String?
    var colorB: String?
    // 画像
    var imageView: UIImageView?
    
    // 初期化
    init(name:String, r:String, g:String, b: String) {
        colorName = name
        colorR = r
        colorG = g
        colorB = b
    }
    
    // RGBの値を用いてImageViewのbackgroundColorを変換する
    func change(r: String, g: String, b: String) {
        
//        imageView?.sd_setImage(with: URL(string: url), completed: nil)
        
    }
    
//    // RGBの値をHSVに変換する
    func changeHSV(r: String, g: String, b: String) -> HSV {
        let red = Int(r)
        let green = Int(g)
        let blue = Int(b)
        
        let r = Double(red!) / 255
        let g = Double(green!) / 255
        let b = Double(blue!) / 255
        
        let maxValue = max(max(r, g), b)
        let minValue = min(min(r, g), b)
        let sub = maxValue - minValue
        
        var h: Double = 0
        var s: Double = 0
        var v: Double = 0
        
        if sub == 0 {
            h = 0
        } else {
            if (maxValue == r) {
                h = (60 * (g - b) / sub) + 0
            } else if (maxValue == g) {
                h = (60 * (b - r) / sub) + 120
            } else if (maxValue == b) {
                h = (60 * (r - g) / sub) + 240
            }
            
            if (h < 0) {
                h += 360
            }
        }
        
        if (maxValue > 0) {
            
            s = sub / maxValue * 100
            
        }
        
        v = maxValue * 100
        
        return HSV(hue: floor(h), saturation: floor(s), value: floor(v))
    }
    // RGBの値をHEXに変換する
    func changeHEX(r: String, g: String, b: String) -> String {
        let r = Int(r)
        let g = Int(g)
        let b = Int(b)
        return String(NSString(format: "%02X%02X%02X", r!,g!,b!))
    }
    
}


class HSV:NSObject {
    
    //色相
    var hue: Double = 0
    
    //彩度
    var saturation: Double = 0
    
    //明度
    var value: Double = 0
    
    init(hue: Double, saturation: Double, value: Double) {
        self.hue = hue
        self.saturation = saturation
        self.value = value
    }
}

