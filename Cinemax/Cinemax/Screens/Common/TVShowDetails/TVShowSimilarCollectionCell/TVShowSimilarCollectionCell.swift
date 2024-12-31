//
//  TVShowSimilarCollectionCell.swift
//  Cinemax
//
//  Created by IPS-161 on 28/03/24.
//

import UIKit

class TVShowSimilarCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var tvShowImg: UIImageView!
    
    override func prepareForReuse() {
        tvShowImg.image = nil
    }
    
    func configure(tvShow:TVShowsResponseModelResult){
        tvShowImg.WebImageLoadingFactory(urlString: WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: tvShow.posterPath), placeholder:"frame.fill")
    }
    
}
