//
//  SearchVC.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

protocol SearchVCProtocol: AnyObject {
    func updateUI()
}

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBarOutlet: UITextField!
    @IBOutlet weak var searchResultTblOutlet: UITableView!
    @IBOutlet weak var searchMessageView: UIView!
    @IBOutlet weak var searchBarView: RoundedCornerView!
    
    var presenter: SearchVCPresenterProtocol?
    let disposeBag = DisposeBag()
    let dropDown = DropDown()
    let previousSearchData = ReplayRelay<String>.create(bufferSize:10)
    var searchQuery = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        bindSearchBar()
        setupDropdown()
        presenter?.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    @IBAction func clearSearchbtnPressed(_ sender: UIButton) {
        searchBarOutlet.text = nil
        UIView.transition(with: searchMessageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.searchMessageView.isHidden = false
        },completion: nil)
    }
    
}

extension SearchVC: SearchVCProtocol {
    
    func bindSearchBar(){
        searchBarOutlet.rx.text.orEmpty
            .debounce(.microseconds(600), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(to: presenter!.searchQuery)
            .disposed(by: disposeBag)
        searchBarOutlet.delegate = self
    }
    
    func registerXib(){
        let nib = UINib(nibName: "MoviesCell", bundle: nil)
        searchResultTblOutlet.register(nib, forCellReuseIdentifier: "MoviesCell")
    }
    
    func updateUI(){
        UIView.transition(with: searchResultTblOutlet,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.searchResultTblOutlet.reloadData()
            self.searchMessageView.isHidden = true
        },completion: nil)
    }
    
    func setupDropdown(){
        dropDown.anchorView = searchBarView
        previousSearchData
            .map { $0 } // Extract the search query from the event
            .compactMap { $0 } // Remove nil values
            .subscribe(onNext: { [weak self] data in
                self?.searchQuery.append(data)
                self?.dropDown.dataSource = self?.searchQuery ?? []
            })
            .disposed(by: disposeBag)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.presenter?.fetchSearchedMoviesAndTVShows(query:item)
        }
    }
    
}

extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        if indexPath.section == 0{
            guard let cellData = presenter?.moviesDatasource else {
                return UITableViewCell()
            }
            cell.dataSource = cellData
            cell.cellTitleData = "Movies"
            cell.cellTappedClosure = { [weak self] movieData in
                if let movieData = movieData , let movieId = movieData.id {
                    self?.presenter?.gotoDetailVC(movieId: movieId)
                }
            }
            cell.seeAllBtnPressedClosure = { [weak self] in
                self?.presenter?.gotoSeeAllVC(page: 1, searchText: self?.searchBarOutlet.text , movieId: 0, seeAllVCInputs: SeeAllVCInputs.fetchMovieSearch(title:self?.searchBarOutlet.text ?? ""))
            }
            return cell
        }else if indexPath.section == 1{
            guard let cellData = presenter?.tvShowsDatasource else {
                return UITableViewCell()
            }
            cell.dataSource = cellData
            cell.cellTitleData = "TV Shows"
            cell.cellTappedClosure = { [weak self] showData in
                if let showData = showData , let showId = showData.id {
                    self?.presenter?.gotoTVShowDetailsVC(tvShowId:showId)
                }
            }
            cell.seeAllBtnPressedClosure = { [weak self] in
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown.show()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropDown.hide()
        if let searchQuery = searchBarOutlet.text {
            previousSearchData.accept(searchQuery)
        }
    }
}

