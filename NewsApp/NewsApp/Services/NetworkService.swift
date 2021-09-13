//
//  NetworkService.swift
//  NewsApp
//
//  Created by George on 8.09.21.
//

import UIKit

class NetworkService {

    private init() { }

    static let shared = NetworkService()

    let mainUrl = "https://newsapi.org/v2/everything?q=apple&from="
    let dateTo = "&to="
    let sortNews = "&sortBy=popularity"
    let apiKey = "&apiKey=956547a231a64bb2b5dc68acc290a913"

    let session = URLSession(configuration: .default)

    func getImage(imageURL: String, imageView: UIImageView, indicator: UIActivityIndicatorView) {
        guard let url = URL(string: imageURL) else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let response = response {
                print(response)
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    imageView.image = image
                }
            }
        }.resume()
    }

    func getNews(from: String, to: String, onSuccess: @escaping ([Article]) -> Void, onError: @escaping (String) -> Void) {
        let url = mainUrl + from + dateTo + to + sortNews + apiKey
        guard let url = URL(string: url) else {
            onError("Error building URL")
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }

                do {
                    if response.statusCode == 200 {
                        let result = try JSONDecoder().decode(Result.self, from: data)
                        print("Articles: \(result.articles.count)")
                        onSuccess(result.articles)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

}
