//
//  UserTimelineTableViewController.swift
//  PortfolioSocial
//
//  Created by Valentina Henao on 6/16/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import UIKit
import Social
import Accounts

class UserTimelineTableViewController: UITableViewController {

    var tweets = [[Tweet]]()
    var dataSource = [AnyObject]()

    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func postTweet(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Tweet", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = ""
        }
        alertController.addAction(UIAlertAction(title: "Publicar", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        tableView.contentMode = .ScaleAspectFit
        self.tableView.rowHeight = 100.0
        
        
    
        refresh(refreshControl)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
//         let request = TwitterRequest(search: "valenhear", count: 100)
//        request.fetchTweets { (newTweets) -> Void in
//                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                        if newTweets.count > 0 {
//                            self.tweets.insert(newTweets, atIndex: 0)
        getTimeLine()
                            self.tableView.reloadData()
                            sender?.endRefreshing()
//                        }
//                    }
//                }
        }
    

    // MARK: - Table view data source
    
    var textlabel = ["ass", "hoe"]
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return tweets.count
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return tweets[section].count
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        return dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timelinecell", forIndexPath: indexPath)
        
//         let tweet = tweets[indexPath.section][indexPath.row]
//        
//        cell.textLabel?.text = "\(tweet.user)"
//        cell.detailTextLabel?.text = tweet.text
        
        

        
        let tweet = dataSource[indexPath.row] as! NSDictionary
        
        let date = tweet.objectForKey("created_at") as! String
        
            let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        
        if let dateWithFormat = formatter.dateFromString(date) {
            
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            let date = formatter.stringFromDate(dateWithFormat)
        cell.textLabel?.text = date
        }
        

        
        
        cell.detailTextLabel?.text = tweet.objectForKey("text") as? String
        cell.detailTextLabel?.numberOfLines = 0
        print(tweet)
    
        
         return cell

    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getTimeLine() {
        
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil, completion: {(success: Bool, error: NSError!) -> Void in
            
            if success {
                let arrayOfAccounts =
                    account.accountsWithAccountType(accountType)
                
                if arrayOfAccounts.count > 0 {
                    let twitterAccount = arrayOfAccounts.last as! ACAccount
                    
                    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
                    
                    let parameters = ["screen_name" : "@maurocasval", "include_rts" : "0", "trim_user" : "1", "count" : "20"]
                    
                    let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameters)
                    
                    postRequest.account = twitterAccount
                    
                    postRequest.performRequestWithHandler(
                        {(responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
//                            var err: NSError?
                            
                                self.dataSource = try! NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
                            
                            if self.dataSource.count != 0 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableView.reloadData()
                                }
                            }
                    })
                }
            } else {
                print("Failed to access account")
            }
        })
        
        
    }

}
