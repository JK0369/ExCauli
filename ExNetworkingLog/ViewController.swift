//
//  ViewController.swift
//  ExNetworkingLog
//
//  Created by Jake.K on 2021/12/30.
//

import UIKit

enum NetworkError: Error {
  case unknown
}

class ViewController: UIViewController {
  
  private let imageButton: UIButton = {
    let button = UIButton()
    button.setTitle("버튼", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(imageButton)
    self.view.addSubview(imageView)
    
    self.imageButton.translatesAutoresizingMaskIntoConstraints = false
    self.imageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.imageButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
    self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
    self.imageButton.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
  }
  @objc private func didSelectButton() {
    let urlString = "https://live.staticflickr.com/65535/51787016201_38f9b305b1_m.jpg"
    guard let imageUrl = URL(string: urlString) else {
      return
    }
    imageDownload(url: imageUrl) { [weak self] result in
      DispatchQueue.main.async {
        self?.imageView.image = try? result.get()
      }
    }
  }
  
  private func imageDownload(url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse,
          httpURLResponse.statusCode == 200,
        let data = data,
        error == nil,
        let image = UIImage(data: data)
      else {
        completion(.failure(.unknown))
        return
      }
      completion(.success(image))
    }.resume()
  }
}
