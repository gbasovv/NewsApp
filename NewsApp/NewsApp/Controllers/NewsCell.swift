//
//  NewsCell.swift
//  NewsApp
//
//  Created by George on 8.09.21.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var publishedAtLbl: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }

    func configure(article: Article) {

        self.publishedAtLbl.text = GlobalFunctions.shared.formatDate(date: article.publishedAt)
        
        self.titleLbl.text = article.title
        self.titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        guard let count = descriptionLbl.text?.count else { return }
        if count > 3 {
            let readmoreFont = UIFont(name: "Montserrat", size: 11.0)
            let readmoreFontColor = #colorLiteral(red: 0.3058823529, green: 0.662745098, blue: 0.9921568627, alpha: 1)
            DispatchQueue.main.async {
                self.descriptionLbl.addTrailing(with: "... ", moreText: "Show More", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
            }
        }
        self.descriptionLbl.text = article.description

        self.newsImage.layer.cornerRadius = 6
        self.newsImage.layer.masksToBounds = true
        self.newsImage.clipsToBounds = true
        if let imageURL = article.urlToImage {
            NetworkService.shared.getImage(imageURL: imageURL, imageView: self.newsImage, indicator: self.activityIndicator)
        } else {
            self.newsImage.image = UIImage(named: "placeholder")
        }
        self.activityIndicator.stopAnimating()
    }
}

