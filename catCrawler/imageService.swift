//
//  imageService.swift
//  catCrawler
//
//  Created by 차윤범 on 2022/07/03.
//

// url에서 이미지를 다운받아 이미지를 만들어주는 서비스

import Foundation
import UIKit

class ImageService{
    
    // 어디서든 사용할 수 있도록 싱글톤 패턴
    static let shared = ImageService()
       
    enum Network :Error{
        case networkError
    }
    
    // 이미지 캐싱 NSCache는 캐시를 담아두었다가 메모리가 부족하면 자동으로 삭제
    private let cache = NSCache<NSString, UIImage>()
    
    // download를 통해 UIImageView에 set, cell에서 생성 ㄱㄱ
    func setImage(view: UIImageView, urlString: String) ->
    URLSessionDataTask? {
        if let image = cache.object(forKey: urlString as NSString){
            view.image = image
            return nil
        }
        
        // 순환 참조를 피하기 위해 weak self
        return self.downloadImage(urlString: urlString){ [weak self]
            result in
            guard let self = self else { return }
            
            DispatchQueue.main.async{
                
                switch result{
                case .failure(let error):
                    return
                case .success(let image):
                    UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve ){
                        
                    } completion: { _ in
                         
                    }
                    self.cache.setObject(image, forKey: urlString as NSString)
                    view.image = image
                }
            }
        }
    }
    
    
    // download module
    // escaping: 성공 시 urlImage, 실패 시 error를 가지도록
    func downloadImage(urlString: String, completion: @escaping(Result<UIImage, Network>) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){
            data, request, error in
            
            guard error == nil else {
                completion(.failure(.networkError))
                return
                
            }
            
            guard let data = data else{
                completion(.failure(.networkError))
                return
                
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(image ))
            
        }
        task.resume()
        
        // cell이 이미지를 다운받고 있으면 취소
        //task.cancel()
        return task
    }
     
}
