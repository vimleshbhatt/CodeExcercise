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

/**
 * A class which manages the components on the HomeViewController.
 
 */
class HomeViewController: UIViewController {
    
    /** The table which will display the information on its view. */
    var tableView: UITableView!
    
    /** The colelction will hold InformationSummary mode objects and will be used to populate data on the table. */
    var results = [InformationSummary]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /** Instance variable used to make service call and fetch data from server. */
    var dataTask: URLSessionDataTask?
    
    /** Instance variable for the session created to fetch data from server. */
    lazy var dataSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        return session
    }()
    
    /**
     * View controller life cycle's method used to configure conponents added to the view.
     * Method will be called once the view is loaded into memory and any custom configuration could be done here.
     *
     */
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
    
    /**
     * Method will configure the table by adding constraints and other appropriate properties to it. Also it will add the pull to refresh functionality to the table.
     * @param data : None
     *
     */
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
    
    /**
     * Method will use the session to initiate the data task and fetch the response from the server.
     *
     */
    func fetchDetails() {
        
        Toast.showPositiveMessage(message: "Fetching information")
        
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
            
            // Check for error and print the localized description for the same.
            if let error = error {
                print(error.localizedDescription)
                Toast.showNegativeMessage(message: "Could not display information now.")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateSearchResults(data)
                }
            }
        }
        
        // Start the task
        dataTask?.resume()
    }

    /**
     * Method will help parse the received data into appropriate business object.
     * This helper method helps parse response JSON NSData into an array of InformationSummary objects.
     *@param data : Data received from remote server.
     *
     */
    func updateSearchResults(_ data: Data?) {
        Toast.showPositiveMessage(message: "Parsing information")
        results.removeAll()
        do {
            
            let responseStrInISOLatin = String(data: data!, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? [String: AnyObject]
                // Get the results array
                if let array: AnyObject = response?["rows"] {
                    for infoDictionary in array as! [AnyObject]{
                        // Parse the search result into appropriate InformationSummary business model.
                        let title = infoDictionary["title"] as? String
                        let description = infoDictionary["description"] as? String
                        let imageRef = infoDictionary["imageHref"] as? String
                        results.append(InformationSummary(title: title, description: description, imageRef: imageRef))
                    }
                } else {
                    print("Key not found in dictionary")
                    Toast.showNegativeMessage(message: "Could not load at this time.")
                }
            } catch {
                print("Error parsing results: \(error.localizedDescription)")
                Toast.showNegativeMessage(message: "Issue with loading data")
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            Toast.showPositiveMessage(message: "Updating information")
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
}

