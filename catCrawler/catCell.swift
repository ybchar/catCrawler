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
    
    private let service = ImageService.shared
    
    private var task: URLSessionDataTask?
    
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
        //self.imageView.backgroundColor = .darkGray
        
        // 이미지를 꽉 채워주는 효과
        self.imageView.contentMode = .scaleAspectFill
        
        self.imageView.clipsToBounds = true
        
    }
    
    func setupData (urlString: String, detail: Bool = false){
        // 이전에 받아온 task가 있다면 cancel
        task?.cancel()
        self.imageView.image = nil
        
        // detail true 이면 scaleAspectFit으로 
        if detail {
            self.imageView.contentMode = .scaleAspectFit
        }
        task = service.setImage(view: self.imageView, urlString: urlString) 
        
    }
}
