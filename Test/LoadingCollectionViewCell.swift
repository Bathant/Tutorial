//
//  LoadingCollectionViewCell.swift
//  Test
//
//  Created by Bathanti on 8/27/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func awakeFromNib() {
        self.spinner.startAnimating()
    }
    
    func stopLoading() {
        self.spinner.stopAnimating()
    }
}
