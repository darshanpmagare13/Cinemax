//
//  MoviesGalleryCollectionViewCell.swift
//  Cinemax
//
//  Created by IPS-161 on 22/03/24.
//

import UIKit
import YoutubePlayer_in_WKWebView

class MoviesGalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieVideoView: WKYTPlayerView!
    @IBOutlet weak var movieVideoTitleLbl: UILabel!
    
    override func prepareForReuse(){
        movieVideoTitleLbl.text = nil
    }
    
    func configure(trailer:Trailer){
        if let trailerKey = trailer.key , let trailerTitle = trailer.name {
            if let myVideoURL = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") {
                DispatchQueue.main.async { [weak self] in
                    self?.movieVideoView.load(withVideoId: trailerKey)
                    self?.movieVideoTitleLbl.text = trailerTitle
                }
            }
        }
    }
    
}
