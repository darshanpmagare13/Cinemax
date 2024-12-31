//
//  SeeAllVC.swift
//  Cinemax
//
//  Created by IPS-161 on 18/03/24.
//

import UIKit
import RxSwift

protocol SeeAllVCProtocol: AnyObject {
    func updateUI()
    func registerXibs()
    func setupFlowlayout()
    func updateCollectionView()
    func showLoader()
    func hideLoader()
}

class SeeAllVC: UIViewController {
    
    @IBOutlet weak var moviesHeadlineLbl: UILabel!
    @IBOutlet weak var moviesCollectionviewOutlet: UICollectionView!
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var sortByLbl: UILabel!
    @IBOutlet weak var gridBtn: UIButton!
    var sortByString : String? {
        didSet{
            sortByLbl.text = sortByString ?? ""
        }
    }
    var scrollConset: CGPoint = .zero
    var isGridLayout : Bool = true {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.setupFlowlayout()
                UIView.transition(with: self!.collectionView,
                                  duration: 0.5,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                    self?.moviesCollectionviewOutlet.reloadData()
                    self?.moviesCollectionviewOutlet.setContentOffset(self?.scrollConset ?? .zero, animated: true)
                },completion: nil)
                self?.gridBtn.setImage(UIImage(systemName: (self!.isGridLayout ? "square.grid.3x3.fill":"line.3.horizontal")), for: .normal)
            }
        }
    }
    var presenter: SeeAllVCPresenterProtocol?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
    }
    
    @IBAction func gridLayoutBtnPressed(_ sender: UIButton) {
        isGridLayout.toggle()
    }
    
    @IBAction func sortedBtnPressed(_ sender: UIButton) {
        showSortingMenu(sender:sender)
    }
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
}

extension SeeAllVC : SeeAllVCProtocol {
    
    func updateUI(){
        if let moviesHeadline = presenter?.moviesHeadline {
            moviesHeadlineLbl.text =  moviesHeadline
        }
    }
    
    func registerXibs(){
        let nib1 = UINib(nibName: "MoviesCollectionViewCell", bundle: nil)
        let nib2 = UINib(nibName: "MoviesCollectionViewDetailCell", bundle: nil)
        moviesCollectionviewOutlet.register(nib1, forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        moviesCollectionviewOutlet.register(nib2, forCellWithReuseIdentifier: "MoviesCollectionViewDetailCell")
    }
    
    func setupFlowlayout(){
        let flowLayout = UICollectionViewFlowLayout()
        if isGridLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 15
            let cellWidth = (moviesCollectionviewOutlet.frame.size.width / 2) - 8
            let height = (moviesCollectionviewOutlet.frame.size.height/2) - 8
            flowLayout.itemSize = CGSize(width: cellWidth, height: height)
            moviesCollectionviewOutlet.collectionViewLayout = flowLayout
        }else{
            let cellWidth = moviesCollectionviewOutlet.frame.size.width - 5
            let height = (moviesCollectionviewOutlet.frame.size.height/2) - 5
            flowLayout.itemSize = CGSize(width: cellWidth, height: height)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 15
            moviesCollectionviewOutlet.collectionViewLayout = flowLayout
        }
    }
    
    func updateCollectionView(){
        UIView.transition(with: moviesCollectionviewOutlet,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {
            self.moviesCollectionviewOutlet.reloadData()
        },completion: nil)
    }
    
    private func showSortingMenu(sender:UIButton){
        // Define actions for sorting
        let sortByRatingAction = UIAction(title: "Rating", image: UIImage(systemName: "star.fill")) { _ in
            self.sortByString = "Sort by Rating"
            self.presenter?.sortMovies(sortBy: SortMovies.byRating)
        }
        let sortByNameAZAction = UIAction(title: "Name A-Z", image: UIImage(systemName: "abc")) { _ in
            self.sortByString = "Sort by Name A-Z"
            self.presenter?.sortMovies(sortBy: SortMovies.byNameAZ)
        }
        let sortByNameZAAction = UIAction(title: "Name Z-A", image: UIImage(systemName: "abc")) { _ in
            self.sortByString = "Sort by Name Z-A"
            self.presenter?.sortMovies(sortBy: SortMovies.byNameZA)
        }
        // Create a menu with sorting options
        let sortingMenu = UIMenu(title: "Sort By", children: [sortByRatingAction, sortByNameAZAction,sortByNameZAAction])
        // Show menu
        let menuButton = sender
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = sortingMenu
    }
}

extension SeeAllVC {
    
    func showLoader(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.moviesCollectionviewOutlet.showLoadingView(backgroundColor: .clear, indicatorColor: .white)
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.moviesCollectionviewOutlet.dismissLoadingView()
        }
    }
    
}


extension SeeAllVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGridLayout {
            return presenter?.moviesDatasourceForCell.count ?? 0
        }else{
            return presenter?.moviesDatasourceIndetailForCell.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridLayout {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as!
            MoviesCollectionViewCell
            guard let cellData = presenter?.moviesDatasourceForCell[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(cellData: cellData)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewDetailCell", for: indexPath) as! MoviesCollectionViewDetailCell
            if let cellData = presenter?.moviesDatasourceIndetailForCell[indexPath.row] {
                cell.configure(cellData: cellData)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let categories = presenter?.seeAllVCInputs,
           let cellDataForCell1 = presenter?.moviesDatasourceForCell[indexPath.row],
           let cellDataForCell2 = presenter?.moviesDatasourceIndetailForCell[indexPath.row]{
            switch categories {
            case .fetchMovieUpcoming(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMovieNowPlaying(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMovieTopRated(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMoviePopular(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMovieSimilar(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMovieSearch(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchMoviesByGenres(_):
                presenter?.gotoDetailVC(movieId: cellDataForCell1.cellId)
            case .fetchTVShowByGenres(_):
                presenter?.gotoTVShowDetailsVC(tvShowId: cellDataForCell2.movieId)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if collectionView is currently displaying grid layout
        if isGridLayout {
            // Check if it's the last item in the grid datasource array
            if indexPath.row == ((presenter?.moviesDatasourceForCell.count ?? 0) - 1) {
                presenter?.loadPaginatedData()
            }
        } else {
            // Check if it's the last item in the list datasource array
            if indexPath.row == ((presenter?.moviesDatasourceIndetailForCell.count ?? 0) - 1) {
                presenter?.loadPaginatedData()
            }
        }
    }
    
    
}

extension SeeAllVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollConset = scrollView.contentOffset
    }
}
