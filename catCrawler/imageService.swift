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
    
    // download를 통해 UIImageView에 set, cell에서 생성 ㄱㄱ
    func setImage(view: UIImageView, urlString: String){
        self.downloadImage(urlString: urlString){
            result in
            
            DispatchQueue.main.async{
                
                switch result{
                case .failure(let error):
                    return
                case .success(let image):
                    view.image = image
                }
            }
        }
    }
    
    
    // download module
    // escaping: 성공 시 urlImage, 실패 시 error를 가지도록
    func downloadImage(urlString: String, completion: @escaping(Result<UIImage, Network>) -> Void){
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
    }
     
}
