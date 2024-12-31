//
//  MoviesCollectionViewDetailCell.swift
//  Cinemax
//
//  Created by IPS-161 on 19/03/24.
//

import UIKit

class MoviesCollectionViewDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieGenereLbl: UILabel!
    @IBOutlet weak var movieLanguageLbl: UILabel!
    @IBOutlet weak var movieOverviewLbl: UILabel!
    @IBOutlet weak var movieRatingLbl: UILabel!
    
    override func prepareForReuse() {
        movieImg.image = nil
        movieNameLbl.text = nil
        movieReleaseDate.text = nil
        movieDuration.text = nil
        movieGenereLbl.text = nil
        movieLanguageLbl.text = nil
        movieOverviewLbl.text = nil
        movieRatingLbl.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(cellData:MoviesCollectionViewDetailCellModel){
        DispatchQueue.main.async { [weak self] in
            self?.movieImg.WebImageLoadingFactory(urlString: cellData.movieImgUrl, placeholder: "frame.fill")
            self?.movieNameLbl.text = cellData.movieNameLblText
            self?.movieReleaseDate.text = cellData.movieReleaseDateText
            self?.movieDuration.text = cellData.movieDurationText
            self?.movieGenereLbl.text = cellData.movieGenereLblText
            self?.movieLanguageLbl.text = cellData.movieLanguageLblText
            self?.movieOverviewLbl.text = cellData.movieOverviewLblText
            self?.movieRatingLbl.text = String(format: "%.1f",cellData.movieRatingLblText)
        }
    }
    
}

struct MoviesCollectionViewDetailCellModel {
    let movieId: Int
    let movieImgUrl:String
    let movieNameLblText:String
    let movieReleaseDateText:String
    let movieDurationText:String
    let movieGenereLblText:String
    let movieLanguageLblText:String
    let movieOverviewLblText:String
    let movieRatingLblText:Double
    init(movieId: Int,movieImgUrl:String,movieNameLblText:String,movieReleaseDateText:String,movieDurationText:String,movieGenereLblText:String,movieLanguageLblText:String,movieOverviewLblText:String,movieRatingLblText:Double){
        self.movieId = movieId
        self.movieImgUrl = WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: movieImgUrl)
        self.movieNameLblText = movieNameLblText
        self.movieReleaseDateText = movieReleaseDateText
        self.movieDurationText = "\(movieDurationText) mins"
        self.movieGenereLblText = movieGenereLblText
        self.movieLanguageLblText = movieLanguageLblText
        self.movieOverviewLblText = movieOverviewLblText
        self.movieRatingLblText = movieRatingLblText
    }
}
