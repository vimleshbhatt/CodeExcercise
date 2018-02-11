//
//  HomeViewController.swift
//  CodeExcercise
//
//  Created by fgb on 2/11/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation
import UIKit
import DGElasticPullToRefresh
import SnapKit

let pullToRefreshFillBgColor = UIColor(red: 247/255.0, green: 180/255.0, blue: 68/255.0, alpha: 1.0)
let pullToRefreshLoadingIndicatorTintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)

class HomeViewController: UIViewController {
    
    // MARK: Properties
    var tableView: UITableView!
    
    var results = [InformationSummary]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Will use the URLSessionDataTask to fetch the information from remote server.
    var dataTask: URLSessionDataTask?
    
    // Session to make the API call,
    lazy var dataSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        return session
    }()
    
    // MARK: ViewController Setup
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup components in the view.
        configureView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    //----------------------------
    // MARK: VIEW SETUP FUCNTIONS
    //----------------------------
    fileprivate func configureView(){
        
        // Setting background color of the navigationBar
        UINavigationBar.appearance().barTintColor = pullToRefreshFillBgColor
        
        // Create a table to show details about the country.
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView!)
        
        // Add constraints to the table and align it to the center of the view.
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
            make.center.equalTo(self.view)
        }
        
        // Add the Pull to refresh control.
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = pullToRefreshLoadingIndicatorTintColor
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.tableView.dg_stopLoading()
                self?.fetchDetails()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(pullToRefreshFillBgColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        // Register custom cells for table view.
        registercells()
    }
    
    fileprivate func registercells(){
        tableView.register(QuickInfoCell.self, forCellReuseIdentifier: "infoCell")
        tableView.estimatedRowHeight = 100
        
        // Initiate the call to fetch details.
        fetchDetails()
    }
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as!QuickInfoCell
        cell.setupWithInformation(info: results[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // We will create auto reszing cells and accomodate contents accordingly.
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController{
    
    func fetchDetails(){
        // Cancel is initiated for the task.
        if dataTask != nil {
            dataTask?.cancel()
        }
        // Start the network activity indicator to show the progress.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Prepare the url from where we will download the information
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        
        // Initiate the task with the url.
        dataTask = dataSession.dataTask(with: url!) { data, response, error in
            // Check for error and update the results to the table.
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            // Vheck for error and print the localized description for the same.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateSearchResults(data)
                }
            }
        }
        
        // Start the task
        dataTask?.resume()
    }
    
    // MARK: Handling Results
    
    // This helper method helps parse response JSON NSData into an array of InformationSummary objects.
    func updateSearchResults(_ data: Data?) {
        results.removeAll()
        do {
            
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["rows"] {
                    
                    for infoDictionary in array as! [AnyObject]{
                        // Parse the search result into appropriate InformationSummary business model.
                        let title = infoDictionary["title"] as? String
                        let description = infoDictionary["description"] as? String
                        let imageRef = infoDictionary["imageHref"] as? String
                        results.append(InformationSummary(title: title, description: description, imageRef: imageRef))
                    }
                } else {
                    print("Key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
}

