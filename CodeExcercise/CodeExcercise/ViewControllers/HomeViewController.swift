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

