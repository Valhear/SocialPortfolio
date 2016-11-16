//
//  NewsTableViewCell.swift
//  PortfolioSocial
//
//  Created by Valentina Henao on 6/16/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var tweet : Tweet? {
        didSet { updateUI() }
    }
    
    @IBOutlet weak var tweetTextLabel: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    
    func updateUI() {
        
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel.text = nil
        tweetProfileImageView.image = nil
        dateLabel.text = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
            }
            tweetScreenNameLabel?.text = "\(tweet.user)"
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            let date = formatter.stringFromDate(tweet.created)
            dateLabel.text = date
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
        }
    }
}


