//
//  TaskData.swift
//  IGBlueMon
//
//  Created by bill donner on 3/12/17. 
//

import AppKit

let bicon = NSImage(named:"blue-ball")!
let ricon = NSImage(named:"red-ball")!
let yicon = NSImage(named:"yellow-ball")!

public class TaskData:TaskDataInt {
  
  var icon: NSImage
  var color: NSColor
  var isFolder = false
 
  
  init(idx: Int, status: String, name: String, server: String, uptime: String, description: String, version:String, icon: NSImage,   color: NSColor) {
    self.icon = icon
    self.color = color
    //leftPadding(toLength:7, withPad: "0")
    
    super.init(idx: idx, status: status, name: name, server: server, uptime: uptime, description: description, version: version)
  }
  
}
