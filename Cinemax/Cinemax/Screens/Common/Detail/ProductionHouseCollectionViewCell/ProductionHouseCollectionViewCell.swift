//
//  ProductionHouseCollectionViewCell.swift
//  Cinemax
//
//  Created by IPS-161 on 18/03/24.
//

import UIKit

class ProductionHouseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    func configure(productionCompany:ProductionCompany){
        let name = productionCompany.name
        cellImg.WebImageLoadingFactory(urlString: WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: productionCompany.logoPath), placeholder: "frame.fill")
        cellLbl.text = name
    }
}
