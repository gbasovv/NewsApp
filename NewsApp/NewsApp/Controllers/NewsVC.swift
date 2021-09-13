//
//  NewsVC.swift
//  NewsApp
//
//  Created by George on 10.09.21.
//

import UIKit
import SafariServices

class NewsVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    private var filteredNews: [Article] = []
    private var newsArticles: [Article] = []
    private var neededInterval: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.searchTextField.font = UIFont(name: "Montserrat", size: 17)
        filteredNews = DataService.shared.saveNews
        self.refreshData()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    @objc private func refreshData() {
        neededInterval = 1
        getNews(days: neededInterval, refresh: true)
    }

    private func getNews(days: Int, refresh: Bool = false) {
        if refresh {
            self.tableView.refreshControl?.beginRefreshing()
        }
        NetworkService.shared.getNews(from: GlobalFunctions.shared.getPastDates(days: days), to: GlobalFunctions.shared.getPastDates(days: (days - 1))) { [unowned self] (result) in
            if refresh {
                self.newsArticles.removeAll()
                self.tableView.refreshControl?.endRefreshing()
            }
            self.newsArticles.append(contentsOf: result)

            self.newsArticles.sort { (article1: Article, article2: Article) -> Bool in
                return GlobalFunctions.shared.compareDates(article1.publishedAt, article2.publishedAt)
            }

            self.filteredNews = self.newsArticles

            self.tableView.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }
    }

    @IBAction func saveNews(_ sender: UIButton) {
        DataService.shared.saveNews.removeAll()
        DataService.shared.saveNews.append(contentsOf: newsArticles)
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let article = filteredNews[indexPath.row]
        cell.configure(article: article)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = filteredNews[indexPath.row]
        guard let url = URL(string: article.url ?? "") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsArticles.count - 1 {
            neededInterval += 1
            getNews(days: neededInterval, refresh: false)
        }
    }
}

extension NewsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNews = []
        if !newsArticles.isEmpty {
            if searchText == "" {
                filteredNews = newsArticles
            } else {
                filteredNews = newsArticles.filter({ (news: Article) -> Bool in
                    return news.title!.lowercased().contains(searchText.lowercased())
                })
            }
            self.tableView.reloadData()
        }
        if searchText == "" {
            filteredNews = DataService.shared.saveNews
        } else {
            filteredNews = DataService.shared.saveNews.filter({ (news: Article) -> Bool in
                return news.title!.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
