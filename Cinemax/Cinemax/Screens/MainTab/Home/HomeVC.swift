//
//  HomeVC.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import UIKit
import RxSwift

protocol HomeVCProtocol: class {
    func bindUI()
    func updateUI()
    func registerXib()
    func addRefreshcontroToTableview()
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var userImg: CircleImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var moviesTableViewOutlet: UITableView!
    @IBOutlet weak var moviesBtn: RoundedButton!
    @IBOutlet weak var tvShowsBtn: UIButton!
    @IBOutlet weak var tvShowsView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var tvShowTableViewOutlet: UITableView!
    
    var presenter: HomeVCPresenterProtocol?
    var userDataRepositoryManager: UserDataRepositoryManagerProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.transform = CGAffineTransform(scaleX: 1, y: 1)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataRepositoryManager = UserDataRepositoryManager.shared
        presenter?.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        presenter?.loadDataSource()
    }
    
    @IBAction func contentToggleBtn(_ sender: UIButton) {
        toggleContent(tag:sender.tag)
    }
    
}

extension HomeVC: HomeVCProtocol {
    
    func bindUI(){
        userDataRepositoryManager?.userFirstName.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.userNameLbl.text = element
                }
            }
        }.disposed(by: disposeBag)
        userDataRepositoryManager?.userProfileImageUrl.subscribe{ event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.userImg.WebImageLoadingFactory(urlString: element, placeholder: "person.fill")
                }
            }
        }
    }
    
    func updateUI(){
        self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
        moviesTableViewOutlet.reloadData()
        tvShowTableViewOutlet.reloadData()
    }
    
    func registerXib(){
        let nib = UINib(nibName: "MoviesCell", bundle: nil)
        moviesTableViewOutlet.register(nib, forCellReuseIdentifier: "MoviesCell")
    }
    
    func addRefreshcontroToTableview(){
        moviesTableViewOutlet.addSubview(refreshControl)
    }
    
    private func toggleContent(tag:Int){
        if tag == 0 {
            UIView.transition(with: self.moviesBtn,
                              duration: 0.3,
                              options: .transitionFlipFromRight,
                              animations: {
                self.moviesBtn.backgroundColor = .appBlue
                self.moviesBtn.isUserInteractionEnabled = false
                self.tvShowsBtn.isUserInteractionEnabled = true
                self.tvShowsBtn.backgroundColor = .clear
            },completion: nil)
            UIView.transition(with: self.mainContentView,
                              duration: 0.3,
                              options: .transitionFlipFromRight,
                              animations: {
                self.moviesTableViewOutlet.isHidden = false
                self.tvShowsView.isHidden = true
            },completion: nil)
        }else{
            UIView.transition(with: self.tvShowsBtn,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                self.tvShowsBtn.backgroundColor = .appBlue
                self.moviesBtn.isUserInteractionEnabled = true
                self.tvShowsBtn.isUserInteractionEnabled = false
                self.moviesBtn.backgroundColor = .clear
            },completion: nil)
            UIView.transition(with: self.mainContentView,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                self.moviesTableViewOutlet.isHidden = true
                self.tvShowsView.isHidden = false
            },completion: nil)
        }
    }
    
}

extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case moviesTableViewOutlet:
            return 4
        case tvShowTableViewOutlet:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case moviesTableViewOutlet:
            return 1
        case tvShowTableViewOutlet:
            if section == 0 {
                return 1
            }else{
                return presenter?.tvShowsDatasource?.results?.count ?? 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case moviesTableViewOutlet:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMoviesCell", for: indexPath) as! UpcomingMoviesCell
                DispatchQueue.main.async { [weak self] in
                    if let upcomingMovies = self?.presenter?.movieUpcomingDatasource {
                        cell.configureCell(dataSource: upcomingMovies)
                    }
                }
                
                cell.cellTappedClosure = { [weak self] movieData in
                    if let movieData = movieData , let movieId = movieData.id {
                        self?.presenter?.gotoDetailVC(movieId:movieId)
                    }
                }
                
                cell.seeAllBtnpressedClosure = { [weak self] in
                    self?.presenter?.gotoSeeAllVC(page: 1, searchText: "", movieId: 0, seeAllVCInputs: SeeAllVCInputs.fetchMovieUpcoming(title:"UPCOMING"))
                }
                
                return cell
            }else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
                DispatchQueue.main.async { [weak self] in
                    if let movieTopRated = self?.presenter?.movieTopRatedDatasource {
                        cell.dataSource = movieTopRated
                        cell.cellTitleData = "TOPRATED"
                    }
                }
                
                cell.seeAllBtnPressedClosure = { [weak self] in
                    self?.presenter?.gotoSeeAllVC(page: 1, searchText: "", movieId: 0, seeAllVCInputs: SeeAllVCInputs.fetchMovieTopRated(title:"TOPRATED"))
                }
                
                cell.cellTappedClosure = { [weak self] movieData in
                    if let movieData = movieData , let movieId = movieData.id {
                        self?.presenter?.gotoDetailVC(movieId:movieId)
                    }
                }
                
                return cell
            }else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
                DispatchQueue.main.async { [weak self] in
                    if let movieNowPlaying = self?.presenter?.movieNowPlayingDatasource {
                        cell.dataSource = movieNowPlaying
                        cell.cellTitleData = "NOWPLAYING"
                    }
                }
                
                cell.seeAllBtnPressedClosure = { [weak self] in
                    self?.presenter?.gotoSeeAllVC(page: 1, searchText: "", movieId: 0, seeAllVCInputs: SeeAllVCInputs.fetchMovieNowPlaying(title:"NOWPLAYING"))
                }
                
                cell.cellTappedClosure = { [weak self] movieData in
                    if let movieData = movieData , let movieId = movieData.id {
                        self?.presenter?.gotoDetailVC(movieId:movieId)
                    }
                }
                
                return cell
            }else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
                DispatchQueue.main.async { [weak self] in
                    if let moviePopular = self?.presenter?.moviePopularDatasource {
                        cell.dataSource = moviePopular
                        cell.cellTitleData = "POPULAR"
                    }
                }
                
                cell.seeAllBtnPressedClosure = { [weak self] in
                    self?.presenter?.gotoSeeAllVC(page: 1, searchText: "", movieId: 0, seeAllVCInputs: SeeAllVCInputs.fetchMoviePopular(title:"POPULAR"))
                }
                
                cell.cellTappedClosure = { [weak self] movieData in
                    if let movieData = movieData , let movieId = movieData.id {
                        self?.presenter?.gotoDetailVC(movieId:movieId)
                    }
                }
                
                return cell
            }
            
        case tvShowTableViewOutlet:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowsTableViewCell1", for: indexPath) as!
                TVShowsTableViewCell1
                guard let cellData = presenter?.tvShowsDatasource?.results?[indexPath.row] else {
                    return  UITableViewCell()
                }
                cell.configure(tvShow: cellData)
                cell.playBtnPressedClosure = { [weak self] in
                    self?.presenter?.gotoTVShowDetailsVC(tvShowId: cellData.id)
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowsTableViewCell2", for: indexPath) as! TVShowsTableViewCell2
                guard let cellData = presenter?.tvShowsDatasource?.results?[indexPath.row] else {
                    return  UITableViewCell()
                }
                cell.configure(tvShow: cellData)
                cell.playBtnPressedClosure = { [weak self] in
                    self?.presenter?.gotoTVShowDetailsVC(tvShowId: cellData.id)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
}
