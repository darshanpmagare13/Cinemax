//
//  TVShowDetailsVC.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import UIKit
import YoutubePlayer_in_WKWebView

protocol TVShowDetailsVCProtocol: AnyObject {
    func updateUI(tvShowDetails: TVShowDetailsResponseModel)
    func registerXibs()
}

class TVShowDetailsVC: UIViewController {
    
    @IBOutlet weak var tvShowTitleLbl: UILabel!
    @IBOutlet weak var tvShowForegroundImg: UIImageView!
    @IBOutlet weak var tvShowRatingLbl: UILabel!
    @IBOutlet weak var tvShowsEpisodesLbl: UILabel!
    @IBOutlet weak var tvShowsReleaseDateLbl: UILabel!
    @IBOutlet weak var tvShowOverviewLbl: UILabel!
    @IBOutlet weak var tvShowsSeasonsTBLViewOutlet: UITableView!
    @IBOutlet weak var tvShowActorsCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var tvShowTrailerPlayerView: WKYTPlayerView!
    @IBOutlet weak var similarTVShowsCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var tvShowAddToWishlistBtn: UIButton!
    @IBOutlet weak var showOverView: UIStackView!
    @IBOutlet weak var showSeasonsView: UIStackView!
    @IBOutlet weak var showActorsView: UIStackView!
    @IBOutlet weak var showTrailerView: UIStackView!
    @IBOutlet weak var showSimilarView: UIStackView!
    
    var presenter: TVShowDetailsVCPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
        showOverView.isHidden = true
        showSeasonsView.isHidden = true
        showActorsView.isHidden = true
        showTrailerView.isHidden = true
        showSimilarView.isHidden = true
    }
    
    
    @IBAction func playPauseAndStopBtnPressed(_ sender: UIButton) {
        manageVideoState(tag:sender.tag)
    }
    
    
    @IBAction func seeAllSimilarTVShowsBtnPressed(_ sender: UIButton) {
        presenter?.gotoTVShowSimilarVC()
    }
    
    
    @IBAction func tvShowAddToWishlistBtnPressed(_ sender: UIButton) {
        
    }
    
}

extension TVShowDetailsVC:  TVShowDetailsVCProtocol {
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func registerXibs(){
        let ActorsCollectionViewCellNib = UINib(nibName: "ActorsCollectionViewCell", bundle: nil)
        tvShowActorsCollectionViewOutlet.register(ActorsCollectionViewCellNib, forCellWithReuseIdentifier: "ActorsCollectionViewCell")
        setupFlowLayoutForTVShowActorsCollectionViewOutlet()
    }
    
    func setupFlowLayoutForTVShowActorsCollectionViewOutlet() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        let width = (tvShowActorsCollectionViewOutlet.frame.width)
        let height = (tvShowActorsCollectionViewOutlet.frame.height / 2) - 5
        flowLayout.itemSize = CGSize(width: width, height: height)
        tvShowActorsCollectionViewOutlet.collectionViewLayout = flowLayout
    }
    
    
    func updateUI(tvShowDetails: TVShowDetailsResponseModel){
        if let showOverview = presenter?.tvShowDetails?.overview,(showOverview != "") {
            showOverView.isHidden = false
            tvShowOverviewLbl.text = showOverview
        }
        if let showSeasons = presenter?.tvShowDetails?.seasons,!(showSeasons.isEmpty){
            showSeasonsView.isHidden = false
            tvShowsSeasonsTBLViewOutlet.reloadData()
        }
        if let showActors = presenter?.tvShowCast?.cast,!(showActors.isEmpty){
            showActorsView.isHidden = false
            tvShowActorsCollectionViewOutlet.reloadData()
        }
        if let showTrailer = presenter?.tvShowTrailer?.results,!(showTrailer.isEmpty){
            showTrailerView.isHidden = false
            setupTVShowTrailer()
        }
        if let showSimilar = presenter?.tvShowSimilar?.results,!(showSimilar.isEmpty){
            showSimilarView.isHidden = false
            similarTVShowsCollectionViewOutlet.reloadData()
        }
        tvShowTitleLbl.text = tvShowDetails.name
        tvShowForegroundImg.WebImageLoadingFactory(urlString: WebImgUrlFactory.createUrl(type: .tmdbPosterUrl, inputUrl: tvShowDetails.posterPath), placeholder: "frame.fill")
        let tvShowRating = String(format: "%.1f",tvShowDetails.voteAverage ?? 0.0)
        tvShowRatingLbl.text = tvShowRating
        tvShowsEpisodesLbl.text = "\(tvShowDetails.numberOfEpisodes ?? 0)"
        tvShowsReleaseDateLbl.text = tvShowDetails.firstAirDate?.extractYearFromDateString() ?? ""
    }
    
    func setupTVShowTrailer(){
        if let tvShowTrailer = presenter?.tvShowTrailer,
           let results = tvShowTrailer.results,
           !results.isEmpty,
           let trailerKey = results[0].key {
            DispatchQueue.main.async { [weak self] in
                self?.tvShowTrailerPlayerView.load(withVideoId:trailerKey)
            }
        }else{
            DispatchQueue.main.async { [weak self] in
                self?.tvShowTrailerPlayerView.load(withVideoId: "")
            }
        }
    }
    
    private func manageVideoState(tag:Int){
        if tag == 0 {
            tvShowTrailerPlayerView.playVideo()
        }else if tag == 1 {
            tvShowTrailerPlayerView.pauseVideo()
        }else if tag == 2 {
            tvShowTrailerPlayerView.stopVideo()
        }
    }
    
}

extension TVShowDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tvShowDetails?.seasons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowSeasonsCell", for: indexPath) as! TVShowSeasonsCell
        guard let cellData = presenter?.tvShowDetails?.seasons?[indexPath.row],
              let defaultPosterPath = presenter?.tvShowDetails?.posterPath else {
            return UITableViewCell()
        }
        cell.configure(season: cellData, defaultPosterPath: defaultPosterPath)
        return cell
    }
    
}

extension TVShowDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tvShowActorsCollectionViewOutlet:
            return presenter?.tvShowCast?.cast?.count ?? 0
        case similarTVShowsCollectionViewOutlet:
            return presenter?.tvShowSimilar?.results?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case tvShowActorsCollectionViewOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorsCollectionViewCell", for: indexPath) as! ActorsCollectionViewCell
            guard let cellData = presenter?.tvShowCast?.cast?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(tvShowCast: cellData)
            return cell
        case similarTVShowsCollectionViewOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowSimilarCollectionCell", for: indexPath) as! TVShowSimilarCollectionCell
            guard let cellData = presenter?.tvShowSimilar?.results?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(tvShow: cellData)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case tvShowActorsCollectionViewOutlet:
            print("")
        case similarTVShowsCollectionViewOutlet:
            let tvShowId = presenter?.tvShowSimilar?.results?[indexPath.row].id
            presenter?.gotoTVShowDetailsVC(tvShowId:tvShowId)
        default:
            print("")
        }
    }
    
}
