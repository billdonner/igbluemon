//
//  ViewController.swift
//  igbluwatch
//
//  Created by bill donner on 3/12/17.
//  Copyright © 2017 razeware. All rights reserved.
//

import UIKit
import SafariServices

class IGBlueMonViewController: UITableViewController {
  
  let cr = UIColor(colorLiteralRed: 0.2, green: 0, blue: 0, alpha: 0.7)
  let cg = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.2, alpha: 0.7)
  let cellID = "IGBlueMonCellID"
  
  @IBOutlet var blueView: UIView!
  
  var imageView: UIImageView!
  
  var sortOrder = TaskSortOrdering.server
  var sortAscending = true

  func tictoc() {
    //////////
    TL.reloadTaskList(ordering:sortOrder,ascending:sortAscending)
    TL.runScheduler() // once per second
    //////////
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //////
    TL.setup()
    ///////
    
    imageView =   UIImageView(image: UIImage(named: "blue1024"))
    imageView.contentMode = .scaleAspectFit
    
    // Dynamically size the height of the table view cells
    tableView.estimatedRowHeight = 60.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.backgroundView = imageView
    
    //addBlurEffect()
    
    //////////
    TL.newTaskList()
    //////////
    
    
    //dont setup delegates until tasklist is established
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tictoc() // run one full cycle
    
    // get the timer going once per second
    /// - if you turn off the time nothing will ever display because results from remote calls dont force reloads
    
    
    Timer.scheduledTimer(timeInterval: 1, target: self,
                         selector: #selector(tictoc), userInfo: nil, repeats: true)
 

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TL.tasksCount()
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    //////////
    let item = TL.taskFor(row:indexPath.row)
    //////////
     cell.contentView.backgroundColor = item.status != "200" ? cr : cg
    
    
    cell.textLabel?.text =  item.paddedUptime() + " " + item.name // + " \(item.selfidx)"
    cell.detailTextLabel?.text = item.status + " " + item.server
    
    return cell
    
    
    //    cell.accessoryView?.backgroundColor = cell.contentView.backgroundColor
    //    cell.accessoryView = UIImageView(image: UIImage(named:"disclosure-indicator"))
    //    cell.accessoryView?.frame = CGRect(x:0,y:0,width:40,eight:40)

  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //////////
    let task = TL.taskFor(row:indexPath.row)
    //////////

    let qurl = URL(string:task.server + "/json")
    if let url = qurl {
      let vc = SFSafariViewController(url:url)
      vc.preferredBarTintColor = cg
      vc.preferredControlTintColor = cr
      self.present(vc,animated:true)
    }
      }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    //////////
      let task = TL.taskFor(row:indexPath.row)
    //////////

      let qurl = URL(string:task.server)
      if let url = qurl {
        let vc = SFSafariViewController(url:url)
        vc.preferredBarTintColor = cr
        vc.preferredControlTintColor = cg
        self.present(vc,animated:true)
      }
    }
}
extension IGBlueMonViewController {

  func addBlurEffect(){
    
    // Create the UIVisialEffectView instance with UIBlurEffect
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // CRITICAL - Needs to be false for constraints and rotation to work
    blurView.translatesAutoresizingMaskIntoConstraints = false
    
    // Add as subview so it is "above" the imageView and blurs it
    imageView.addSubview(blurView)
    
    // This is the other way to add the blurView in this example
    // If you choose this way, it is also above the imageView
    // Uncomment imageView.addSubview(blurView) if you want to try it
    //view.insertSubview(blurView, aboveSubview: imageView)
    
    // Constraints to keep size of blurView and view the same
    let topConstraint = NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
    let leftConstraint = NSLayoutConstraint(item: blurView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
    let rightConstraint = NSLayoutConstraint(item: blurView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: blurView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    
    
    tableView.backgroundView =  imageView
    
    // Add the constraints, and now rotation works perfectly so that the
    // blur view does not get out of sync with the view and image rotation
    view.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    
    // Add separatorEffect to give some color and transparency to the separator lines
    tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurView.effect as! UIBlurEffect)
  }
}

