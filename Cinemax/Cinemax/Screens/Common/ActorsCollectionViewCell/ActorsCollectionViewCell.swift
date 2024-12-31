//
//  ActorsCollectionViewCell.swift
//  Cinemax
//
//  Created by IPS-161 on 27/03/24.
//

import UIKit

class ActorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorsCharacter: UILabel!
    
    override func prepareForReuse() {
        actorName.text = nil
        actorsCharacter.text =  nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(tvShowCast:TVShowCast){
        let actorName = tvShowCast.name ?? ""
        let actorsCharacter = tvShowCast.character ?? ""
        DispatchQueue.main.async { [weak self] in
            self?.actorName.text = actorName
            self?.actorsCharacter.text = actorsCharacter
        }
    }
    
}
