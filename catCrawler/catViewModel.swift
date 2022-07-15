//
//  CatViewModel.swift
//  catCrawler
//
//  Created by 차윤범 on 2022/07/03.
//

// view model
import Foundation

// 비동기 작업으로 response을 가져오되 언제 가져오나?
// delegate 방식으로 catch
protocol CatViewModelOutput: AnyObject {
    func loadComplete()
}


final class CatViewModel{
    
    // 현재 페이지 값
    private var currentPage = 0;
    
    // 한번에 21장을 가져온다는 limit
    private var limit = 3*7;
    
    // 만든 서비스와 연결
    private let service = CatService()
    
    // 공간을 담을 데이터
    var data: [CatResponse] = [];
   
    private var delegates : [CatViewModelOutput] = []
    
    func attach(delecate: CatViewModelOutput){
        self.delegates.append(delecate)
    }
    
    func detach(delegate: CatViewModelOutput){
        self.delegates = self.delegates.filter{
            $0 !== delegate
            
        }
    }
    
    var isLoding : Bool = false;
    
    func loadMoreIfNeeded(index: Int){
        if index > data.count - 6 {
            self.load()
        }
    }
    
    // call func
    // response는 비동기 작업으로 가져온다
    func load(){
        
        guard !isLoding else { return }
        self.isLoding = true
        
        self.service.getCats(page: self.currentPage, limit: self.limit){
            result in
            
            DispatchQueue.main.async {
                switch result {
                case.failure(let error):
                    break;
                case.success(let response):
                    self.data.append(contentsOf: response)
                    self.currentPage += 1
                    self.delegates.forEach{
                        $0.loadComplete()
                    }
                    //self.delegate?.loadComplete()
                }
                
                self.isLoding = false
            }
            
            
        }
    }
    
}
