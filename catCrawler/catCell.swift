//
//  catCell.swift
//  catCrawler
//
//  Created by 차윤범 on 2022/06/26.
//
// collection cell 상속받을 cat cell

import Foundation
import UIKit

final class CatCell: UICollectionViewCell{
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder :NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupView(){
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        self.imageView.backgroundColor = .cyan
        self.imageView.contentMode = .scaleAspectFill
    }
}
