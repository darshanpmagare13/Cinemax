//
//  TVShowSimilarVC.swift
//  Cinemax
//
//  Created by IPS-161 on 29/03/24.
//

import UIKit

protocol TVShowSimilarVCProtocol: AnyObject {
    func updateUI()
}

class TVShowSimilarVC: UIViewController {
    
    @IBOutlet weak var similarTVShowsTBLOutlet: UITableView!
    var presenter: TVShowSimilarVCPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
    }
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
}

extension TVShowSimilarVC: TVShowSimilarVCProtocol {
    func updateUI(){
        UIView.transition(with: similarTVShowsTBLOutlet,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {
            self.similarTVShowsTBLOutlet.reloadData()
        },completion: nil)
    }
}

extension TVShowSimilarVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.similarTVShowsData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowSimilarVCTBLCell", for: indexPath) as!
        TVShowSimilarVCTBLCell
        guard let cellData = presenter?.similarTVShowsData[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(tvShow:cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((presenter?.similarTVShowsData.count ?? 0) - 1) {
            presenter?.loadDatasource()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tvShowId = presenter?.similarTVShowsData[indexPath.row].id  {
            presenter?.gotoTVShowDetailsVC(tvShowId:tvShowId)
        }
    }
    
}
