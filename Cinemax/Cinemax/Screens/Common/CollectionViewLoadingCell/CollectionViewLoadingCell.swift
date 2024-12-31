//
//  CollectionViewLoadingCell.swift
//  Cinemax
//
//  Created by IPS-161 on 20/03/24.
//

import UIKit

class CollectionViewLoadingCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
}
