//
//  PostServices.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//

import Foundation
import Alamofire


struct ApiModel: Encodable {
  let earth_date: String
  let camera: String?
  let api_key: String = "yTzJuShoRAR9qAY8zKfGqXVWtwOf9hbubxavVY0g"
  
  var parameters: [String : Any] {
    guard let data = try? JSONEncoder().encode(self) else { return [:] }
    guard let json = try?  JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return [:] }
    return json
  }
}

struct PostServices {
  static let shared = PostServices()
  
  static func fetchRequest(by rover: Rovers, model: ApiModel, completion: @escaping ([Photo]) -> Void) {
    AF.request("https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover.rawValue)/photos", method: .get, parameters: model.parameters).validate().responseData { response in
      switch response.result {
      case .success(let data):
        guard let object = try? JSONDecoder().decode(Model.self, from: data) else { return }
        completion(object.photos)
      case .failure(let error):
        print(error)
      }
    }
  }
}

