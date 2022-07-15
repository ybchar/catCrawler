//
//  DetailViewController.swift
//  catCrawler
//
//  Created by 차윤범 on 2022/06/05.
//

import UIKit

class DetailViewController: UIViewController, CatViewModelOutput {

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // 초기 백그라운드 컬러 지정
        cv.backgroundColor = .white
        
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing =  .zero
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    private let viewModel : CatViewModel
    
    private let index: Int
    
    init(viewModel: CatViewModel, index: Int){
        self.viewModel = viewModel
        self.index = index
        super.init(nibName: nil, bundle: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    private func setupView(){
        self.view.addSubview(self.collectionView)
        
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),

            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //self.collectionView.backgroundColor = .white
        
        self.collectionView.register(CatCell.self, forCellWithReuseIdentifier: "Cell")
        
        // add delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
        // view model self delegate
        //self.viewModel.delegate = self
        self.viewModel.attach(delecate: self)
        // view model load
        self.viewModel.load()
        
        
        // collectionView에 layout을 잡아주고
        self.collectionView.layoutIfNeeded()
        // collectionView에 scrollToItem으로 현재 index를 가져오고 scrollOption은 centeredHorizontally, .
        self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func loadComplete(){
        DispatchQueue.main.async {
            // 현재 url request로 했기 때문에 메인 스레드에 담는 작업을 해야함
            self.collectionView.reloadData()
        }
    }
    
    // 뷰가 사라지기 직전에 delegate 해제되야 메모리가 해제됨
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.detach(delegate: self)
    }
}

extension DetailViewController : UICollectionViewDelegateFlowLayout{
    
    // 스크롤하면 새로운 이미지가 로드되어 덧붙이는 메소드 : willDisplay
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.frame.size
        }
        
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            self.viewModel.loadMoreIfNeeded(index: indexPath.item)
        }
}


extension DetailViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatCell;
        
        
        let data = self.viewModel.data[indexPath.item]
        cell.setupData(urlString: data.url, detail: true )
        return cell
    }
    
    
}
