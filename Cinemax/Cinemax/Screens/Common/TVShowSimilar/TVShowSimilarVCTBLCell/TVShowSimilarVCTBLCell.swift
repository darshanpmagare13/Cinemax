//
//  TVShowSimilarVCTBLCell.swift
//  Cinemax
//
//  Created by IPS-161 on 29/03/24.
//

import UIKit

class TVShowSimilarVCTBLCell: UITableViewCell {
    
    @IBOutlet weak var tvShowImg: UIImageView!
    @IBOutlet weak var tvShowNameLbl: UILabel!
    @IBOutlet weak var tvShowReleaseDateLbl: UILabel!
    
    override func prepareForReuse(){
        tvShowImg.image = nil
        tvShowNameLbl.text = nil
        tvShowReleaseDateLbl.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(tvShow:TVShowsResponseModelResult){
        let tvShowName = tvShow.name
        let tvShowReleaseDate = tvShow.firstAirDate
        DispatchQueue.main.async { [weak self] in
            self?.tvShowImg.WebImageLoadingFactory(urlString: WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl:tvShow.posterPath), placeholder: "frame.fill")
            self?.tvShowNameLbl.text = tvShowName
            self?.tvShowReleaseDateLbl.text = tvShowReleaseDate
        }
    }
    
}
