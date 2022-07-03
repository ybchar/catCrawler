//
//  ViewController.swift
//  catCrawler
//
//  Created by 차윤범 on 2022/06/05.
//

import UIKit

class ViewController: UIViewController, CatViewModelOutput {

    private enum  Metrics {
        static let inset: CGFloat = 4
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 초기 백그라운드 컬러 지정
        cv.backgroundColor = .white
        layout.minimumLineSpacing = Metrics.inset
        layout.minimumInteritemSpacing = Metrics.inset
        return cv
    }()
    
    private let viewModel = CatViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    private func setupView(){
        self.view.addSubview(self.collectionView)
        
        //
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),

            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.collectionView.backgroundColor = .white
        
        self.collectionView.register(CatCell.self, forCellWithReuseIdentifier: "Cell")
        
        // add delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
        // view model self delegate
        self.viewModel.delegate = self
        // view model load
        self.viewModel.load()
    }
    
    func loadComplete(){
        DispatchQueue.main.async {
            // 현재 url request로 했기 때문에 메인 스레드에 담는 작업을 해야함
            self.collectionView.reloadData()
        }
        
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) ->CGSize {
        let width = collectionView.frame.width
        
        let cellWidth = (width - 2 * Metrics.inset) / 3
        
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
}

extension ViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatCell;
        
        let data = self.viewModel.data[indexPath.item]
        cell.setupData(urlString: data.url)
        return cell
    }
    
    
}
