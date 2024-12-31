//
//  TVShowsTableViewCell.swift
//  Cinemax
//
//  Created by IPS-161 on 26/03/24.
//

import UIKit

class TVShowsTableViewCell2: UITableViewCell {
    @IBOutlet weak var tvShowPosterImgView: UIImageView!
    @IBOutlet weak var tvShowNameLbl: UILabel!
    @IBOutlet weak var tvShowRatingLbl: UILabel!
    var playBtnPressedClosure : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        playBtnPressedClosure?()
    }
    
    func configure(tvShow:TVShowsResponseModelResult){
        let movieRating = String(format: "%.1f",tvShow.voteAverage ?? 0.0)
        DispatchQueue.main.async { [weak self] in
            self?.tvShowPosterImgView.WebImageLoadingFactory(urlString: WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: tvShow.posterPath), placeholder: "frame.fill")
            self?.tvShowNameLbl.text = tvShow.name
            self?.tvShowRatingLbl.text = movieRating
        }
    }
    
}
