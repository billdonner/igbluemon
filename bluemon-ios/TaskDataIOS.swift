//
//  TaskData
//  IGBlueMon
//
//  Created by bill donner on 3/12/17.
//

import UIKit

let bicon = UIImage(named:"blue-ball")!
let ricon = UIImage(named:"red-ball")!
let yicon = UIImage(named:"yellow-ball")!

public class TaskData:TaskDataInt {
 
  var icon: UIImage
  var color: UIColor
  var isFolder = false
  
  init(idx: Int, status: String, name: String, server: String, uptime: String, description: String, version:String, icon: UIImage,   color: UIColor) {
    self.icon = icon
    self.color = color
    
    
    super.init(idx: idx, status: status, name: name, server: server, uptime: uptime, description: description, version: version)
  }
 
}
