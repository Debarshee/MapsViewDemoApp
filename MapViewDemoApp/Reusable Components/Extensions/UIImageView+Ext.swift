//
//  UIImageView+Ext.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 5/2/21.
//

import UIKit

extension UIImageView {
    
    static var imageCache = ImageCache()
    
    func downloadImage(with url: String?) {
        guard let unwrappedUrl = url, let mainUrl = URL(string: unwrappedUrl) else {
            self.image = UIImage(named: "defaultPlaceholder")
            return
        }
        
        if let image = UIImageView.imageCache.getImage(for: NSString(string: unwrappedUrl)) {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: mainUrl) { data, _, _ in
            guard let data = data else {
                self.image = UIImage(named: "defaultPlaceholder")
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                UIImageView.imageCache.saveImage(image, for: NSString(string: unwrappedUrl))
                self.image = UIImage(data: data)
            }
        }
        .resume()
    }
}
