//
//  DetailVC.swift
//  Cinemax
//
//  Created by IPS-161 on 14/03/24.
//

import UIKit
import YoutubePlayer_in_WKWebView
import RxSwift
import RxCocoa

protocol DetailVCProtocol : AnyObject {
    func updateUI(movieDetail:MovieDetailsModel)
    func registerXibs()
    func setupFlowlayout()
    func updateSimilarMoviesCollectionviewOutlet()
    func playMovieTrailer()
    func bindLoader()
}

class DetailVC: UIViewController {
    
    @IBOutlet weak var movieBackgroundImg: UIImageView!
    @IBOutlet weak var movieForegroundImg: UIImageView!
    @IBOutlet weak var movieReleasedateLbl: UILabel!
    @IBOutlet weak var movieDurationLbl: UILabel!
    @IBOutlet weak var movieGenereLbl: UILabel!
    @IBOutlet weak var movieRatingLbl: UILabel!
    @IBOutlet weak var movieOverviewlbl: UILabel!
    @IBOutlet weak var similarMoviesCollectionviewOutlet: UICollectionView!
    @IBOutlet weak var similarMoviesCollectionViewsOtletView: RoundedCornerView!
    @IBOutlet weak var productionHouseCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var movieStatus: UILabel!
    @IBOutlet weak var productionHouseCollectionViewOutletView: RoundedCornerView!
    @IBOutlet weak var movieTrailerView: WKYTPlayerView!
    @IBOutlet weak var movieTrailerSectionView: UIView!
    @IBOutlet weak var movieGalleryCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var addToWishListBtn: UIButton!
    @IBOutlet weak var overViewsView: RoundedCornerView!
    
    var presenter : DetailVCPresenterProtocol?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
        productionHouseCollectionViewOutletView.isHidden = true
        movieTrailerSectionView.isHidden = true
        overViewsView.isHidden = true
        similarMoviesCollectionViewsOtletView.isHidden = true
    }
    
    @IBAction func seeAllBtnPressed(_ sender: UIButton) {
        if let movieId = presenter?.movieId, let movieTitle = presenter?.movieDetail?.title {
            presenter?.gotoSeeAllVC(page: 1, searchText: "", movieId: movieId, seeAllVCInputs: SeeAllVCInputs.fetchMovieSimilar(title:movieTitle))
        }
    }
    
    
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        movieTrailerView.playVideo()
    }
    
    @IBAction func pauseBtnPressed(_ sender: UIButton) {
        movieTrailerView.pauseVideo()
    }
    
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        movieTrailerView.stopVideo()
    }
    
    
    @IBAction func addToWishlistBtnPressed(_ sender: UIButton) {
        processAddToWishlist()
    }
    
    
}

extension DetailVC : DetailVCProtocol {
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func updateUI(movieDetail:MovieDetailsModel){
        if let productionHouseCollectionViewData = presenter?.movieProductionHouses, !(productionHouseCollectionViewData.isEmpty){
            productionHouseCollectionViewOutletView.isHidden = false
        }
        if let overView = movieDetail.overview,(overView != "") {
            overViewsView.isHidden = false
        }
        if let movieTrailer = presenter?.movieVideos?.results,!(movieTrailer.isEmpty) {
            movieTrailerSectionView.isHidden = false
        }
        if let similarMovies = presenter?.similarMovies?.results,!(similarMovies.isEmpty){
            similarMoviesCollectionViewsOtletView.isHidden = false
        }
        if let wishlistMoviesId = presenter?.wishlistMoviesIds , let movieId = presenter?.movieId {
            addToWishListBtn.tintColor = (wishlistMoviesId.contains(movieId) ? UIColor.appBlue : UIColor.white)
        }
        productionHouseCollectionViewOutlet.reloadData()
        let movieBackgroundImgUrl = WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: movieDetail.posterPath)
        movieBackgroundImg.WebImageLoadingFactory(urlString: movieBackgroundImgUrl, placeholder: "frame.fill")
        movieForegroundImg.WebImageLoadingFactory(urlString: movieBackgroundImgUrl, placeholder: "frame.fill")
        if let releaseDate = movieDetail.releaseDate,
           let duration = movieDetail.runtime,
           let rating = movieDetail.voteAverage,
           let overView = movieDetail.overview,
           let title = movieDetail.title,
           let status = movieDetail.status{
            movieReleasedateLbl.text = "\(releaseDate)"
            movieDurationLbl.text = "\(duration) mins"
            if let genere = movieDetail.genres,!genere.isEmpty {
                movieGenereLbl.text = "\(genere[0].name ?? "")"
            }else{
                movieGenereLbl.text = "nil"
            }
            let movieRating = String(format: "%.1f",rating)
            movieRatingLbl.text = movieRating
            movieOverviewlbl.text = overView
            movieStatus.text = "Satus:- \(status)"
            movieTitleLbl.text = title
        }
    }
    
    func registerXibs(){
        similarMoviesCollectionviewOutlet.delegate = self
        similarMoviesCollectionviewOutlet.dataSource = self
        let nib = UINib(nibName: "MoviesCollectionViewCell", bundle: nil)
        similarMoviesCollectionviewOutlet.register(nib, forCellWithReuseIdentifier: "MoviesCollectionViewCell")
    }
    
    func updateSimilarMoviesCollectionviewOutlet(){
        similarMoviesCollectionviewOutlet.reloadData()
        if let result = presenter?.similarMovies?.results, !result.isEmpty {
            similarMoviesCollectionViewsOtletView.isHidden = false
        }
    }
    
    func setupFlowlayout(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let width = (movieGalleryCollectionViewOutlet.frame.width)
        let height = (movieGalleryCollectionViewOutlet.frame.height)
        flowLayout.itemSize = CGSize(width: width, height: height)
        movieGalleryCollectionViewOutlet.collectionViewLayout = flowLayout
    }
    
    func playMovieTrailer(){
        if let movieVideosData = presenter?.movieVideos?.results {
            DispatchQueue.main.async { [weak self] in
                self?.movieGalleryCollectionViewOutlet.reloadData()
                if let trailerVideo = movieVideosData.first(where: { $0.type == "Trailer" }),
                   let trailerVideoKey = trailerVideo.key{
                    if let myVideoURL = URL(string: "https://www.youtube.com/watch?v=\(trailerVideoKey)") {
                        self?.movieTrailerView.load(withVideoId: trailerVideoKey)
                    }
                }
            }
        }
    }
    
    private func processAddToWishlist(){
        if let movieTitle = presenter?.movieDetail?.title,
           let wishlistMoviesId = presenter?.wishlistMoviesIds,
           let movieId = presenter?.movieId{
            let popupLblHeadlineInput = (wishlistMoviesId.contains(movieId) ? "Are you sure?":"\(movieTitle) Added To Whishlist.")
            let popupSubheadlineInput = (wishlistMoviesId.contains(movieId) ? "Do you want to remove \(movieTitle) from wishlist?":"\(movieTitle) added successfully to your wishlist you can watch it there.")
            let input = (wishlistMoviesId.contains(movieId) ? CustomPopupVCInputs.asking:CustomPopupVCInputs.success)
            let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: input, popupLblHeadlineInput: popupLblHeadlineInput, popupSubheadlineInput: popupSubheadlineInput)
            customPopVC.modalPresentationStyle = .overCurrentContext
            navigationController?.present(customPopVC,animated: true)
            CustomPopupVCBuilder.okBtnTrigger = {
                self.presenter?.addMovieToWishlist()
                self.addToWishListBtn.tintColor = UIColor.appBlue
            }
            CustomPopupVCBuilder.yesBtnTrigger = {
                self.presenter?.removeMovieFromWishlist()
                self.addToWishListBtn.tintColor = UIColor.white
            }
            CustomPopupVCBuilder.noBtnTrigger = {
                
            }
        }
    }
    
    func bindLoader(){
        presenter?.isLoading.bind(listener: { [weak self] bool in
            guard let bool = bool , let self = self else {
                return
            }
            if bool {
                self.presenter?.showLoader()
            }else {
                self.presenter?.hideLoader()
            }
        })
    }
    
}

extension  DetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case similarMoviesCollectionviewOutlet:
            return presenter?.similarMovies?.results?.count ?? 0
        case productionHouseCollectionViewOutlet:
            return presenter?.movieProductionHouses.count ?? 0
        case movieGalleryCollectionViewOutlet:
            return presenter?.movieVideos?.results?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case similarMoviesCollectionviewOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as!
            MoviesCollectionViewCell
            guard let data = presenter?.similarMovies?.results?[indexPath.row] else {
                return UICollectionViewCell()
            }
            let posterPath = data.posterPath ?? ""
            let title = data.title ?? ""
            let name = data.name ?? ""
            let originalLanguage = data.originalLanguage ?? ""
            let voteAverage = data.voteAverage ?? 0.0
            let cellData = MoviesCollectionViewCellModel(cellId: 0, cellImgUrl:posterPath,
                                                         cellNameLblText:((title == "") ? name:title),
                                                         cellLanguageLblText:originalLanguage,
                                                         cellRatingLblText:voteAverage)
            cell.configure(cellData: cellData)
            return cell
        case productionHouseCollectionViewOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductionHouseCollectionViewCell", for: indexPath) as! ProductionHouseCollectionViewCell
            guard let cellData = presenter?.movieProductionHouses[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(productionCompany: cellData)
            return cell
        case movieGalleryCollectionViewOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesGalleryCollectionViewCell", for: indexPath) as! MoviesGalleryCollectionViewCell
            guard let cellData = presenter?.movieVideos?.results?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(trailer: cellData)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case similarMoviesCollectionviewOutlet:
            if let movieId = presenter?.similarMovies?.results?[indexPath.row].id {
                presenter?.gotoDetailVC(movieId: movieId)
            }
        case productionHouseCollectionViewOutlet:
            print("Production House Tapped")
        default:
            print("Nothing")
        }
    }
    
}

private extension UILabel {
    func toMins(duration: Double){
        let totalMinutes = Int(duration) / 60
        let totalSeconds = Int(duration) % 60
        let totalTimeString = String(format: "%02d:%02d", totalMinutes, totalSeconds)
        self.text = totalTimeString
    }
}
