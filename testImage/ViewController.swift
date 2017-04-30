//
//  ViewController.swift
//  testImage
//
//  Created by longxiang on 2017/4/20.
//  Copyright © 2017年 longxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originImage: UIImageView!
    @IBOutlet weak var convertImage: UIImageView!
    @IBOutlet weak var orignImageBytes: UILabel!
    @IBOutlet weak var compressImageBytes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image  = UIImage.init(named: "test")
        guard let cgImage = image?.cgImage else {
            orignImageBytes.text = "unable to read"
            return
        }
        originImage.image = image
        orignImageBytes.text = "\(cgImage.bytesPerRow * cgImage.height / 1024)" + "KB"
        let tuple = image?.compress(threadhold: 500 * 1024)
        guard let compressImage = tuple?.image, let convertImageData = tuple?.imageData else {
            return
        }
        convertImage.image = compressImage
        try? convertImageData.write(to: URL.init(fileURLWithPath: "/Users/longxiang/Desktop/JavaScript/convertImageData.jpg"), options: Data.WritingOptions.atomic)
        compressImageBytes.text = "\(convertImageData.count / 1024)" + "KB"
    }
}


