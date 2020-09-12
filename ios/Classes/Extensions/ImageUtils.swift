//
//  ImageUtils.swift
//  arkit_plugin
//
//  Created by Anargu on 9/12/20.
//

import Foundation
import UIKit


func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

extension UIImage {
    
    static func downloadImage(from url: URL, onNewImage: @escaping (_ image: UIImage?) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                onNewImage(UIImage(data: data))
            }
        }
    }
}
