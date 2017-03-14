import Foundation

typealias ServerInfo = [String:String]
typealias StatusInfo = [String:Any]

extension String {
  
  func leftPadding(toLength: Int, withPad character: Character) -> String {
    
    let newLength = self.characters.count
    
    if newLength < toLength {
      
      return String(repeatElement(character, count: toLength - newLength)) + self
      
    } else {
      
      return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
      
    }
  }
  
}
public class  TaskDataInt {
  var status: String
  var server: String
  var name: String
  var uptime: String
  var description : String
  var version : String
  var inprogress = false
  var downcount: Int = 1
  var between: Int = 2
  var selfidx: Int
  
  init(idx: Int, status: String, name: String, server: String, uptime: String, description: String, version:String) {
    
    self.selfidx = idx
    self.status = status
    self.name = name
    self.server = server
    self.uptime = uptime
    self.version = version
    self.description = description
    
  }
  
  func paddedUptime()->String {
    
    let str = uptime.components(separatedBy: ".").first!

    if  let xx = Double(str as String) {
      if xx > 0 {
       // let aa = log10(xx)
        //let yy = Int(aa)
        let paddedStr = str.leftPadding(toLength:7,  withPad: "0" )
        return paddedStr
      }
    }
    
    return "?????"
  }
  
  public var debugDescription: String {
    return uptime + " " + "\(server)" + " status: \(status)"
  }
}


struct TL {
  
  
  
  fileprivate static var taskRows: [TaskData] = []
  
  static var info = StatusInfo() //maps url to indicies
    
    static func setup() {
        let bc =   BlueConfig()
        try! bc.process( configurl: nil)
        print(bc.grandConfig)
        print(bc.localConfig)
        
        TL.make(bc.grandConfig["servers"] as! [ServerInfo])
    }
  
  static  func runScheduler() {
    // counts down each task and starts remote api call whenever apvarpriate
    let theRows = TL.taskRows // copy so it can mutate
    // print ("runSched entrance with sss \(sss)")
    var theIndex = 0
    for task in theRows  { // each on list
      
      let dorun = TL.countDown(idx: theIndex)
      let inprog = task.inprogress  //TL.isInProg(url: task.server) // skip if busy
      
      //print("runSched countdown \ {(dorun) inprog \(inprog) for poll \(task.server)")
      
      if dorun && !inprog {
        task.color = .yellow
        task.icon = yicon
        
        // print("runSched will poll \(task.server) idx \(TL.idx(url:task.server))")
        getRemoteStatus(task.server ) { apistatus, status, name,uptime,description,version, server  in
          
          //print("runSched finished poll \(server) idx \(TL.idx(url:server))")
          
          if let merow = TL.idx(url: server) {
            if apistatus == 200 {
              let td =  TL.taskRows[merow ]
              td.status = "\(apistatus)"
              td.name = name
              td.description = description
              td.version = version
              td.server = server
              td.uptime = uptime
              td.color = .blue
              td.icon = bicon
              
            } else {
              // in case of error copy fordward much of the exisating taskdata
              //let td = TL.taskList.taskRows[merow ]
              
              let td =  TL.taskRows[merow ]
              td.status =  "\(status)"
              td.color = .red
              td.icon = ricon
            }
          }
        }//getRemoteStatus
      }// not in progress
      theIndex += 1
    }// for loop
  }// run scheduler
  
  static func reloadTaskList(ordering:TaskSortOrdering,ascending:Bool) {
    //TL.taskList.taskRows = (TL.taskList?.contentsOrderedBy(ordering, ascending: ascending))!
  }
  static func newTaskList() {
    // TL.taskList = TaskList()
  }
  static func taskFor(row:Int) -> TaskData{
    return TL.taskRows[row]
  }
  static func tasksCount()->Int {
    return TL.taskRows.count
  }

  static func idx(url:String) -> Int? {
    if let  t = info[url] as? StatusInfo {
      if  let indez = t["idx"] as? Int {
        return indez
      }
    }
    return nil
  }
  
  //countdown and reset for this entry
  static func countDown(idx:Int) -> Bool {
    
    let td = taskRows[idx]
    td.downcount -= 1
    if td.downcount <= 0 {
      td.downcount   = td.between
      return true
    }
    return false
  }
  
  static func make(_ x:[ServerInfo]) {
    
    var idx = 0
    info = [:]
    for each in x {
      if let bb = each["server"] {
        let blocky = ["server":bb,"idx":idx] as StatusInfo
        info[bb] = blocky   
        taskRows.append(TaskData(idx: idx, status: "100", name:bb, server: bb, uptime: "", description: "", version:"", icon: ricon, color: .red))
        
      }
      
      
      idx += 1
    } // for
  }
}




func contentsOrderedBy(_ orderedBy: TaskSortOrdering, ascending: Bool) -> [TaskData] {
  let sortedFiles: [TaskData]
  switch orderedBy {
  case .status:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending: ascending,
                          attributeComparation:itemComparator(lhs:$0.status, rhs: $1.status, ascending:ascending))
    }
  case .server:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                          attributeComparation:itemComparator(lhs:$0.server, rhs: $1.server, ascending: ascending))
    }
  case .uptime:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                          attributeComparation:itemComparator(lhs:$0.uptime, rhs: $1.uptime, ascending:ascending))
    }
  case .description:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                          attributeComparation:itemComparator(lhs:$0.description, rhs: $1.description, ascending:ascending))
    }
  case .version:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                          attributeComparation:itemComparator(lhs:$0.version, rhs: $1.version, ascending:ascending))
    }
  case .name:
    sortedFiles = TL.taskRows.sorted {
      return sortTaskData(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                          attributeComparation:itemComparator(lhs:$0.name, rhs: $1.name, ascending:ascending))
    }
  }
  return sortedFiles
}


// MARK: - Sorting

func sortTaskData(lhsIsFolder: Bool, rhsIsFolder: Bool,  ascending: Bool,
                  attributeComparation: Bool) -> Bool {
  if(lhsIsFolder && !rhsIsFolder) {
    return ascending ? true : false
  }
  else if (!lhsIsFolder && rhsIsFolder) {
    return ascending ? false : true
  }
  return attributeComparation
}

func itemComparator<T:Comparable>(lhs: T, rhs: T, ascending: Bool) -> Bool {
  return ascending ? (lhs < rhs) : (lhs > rhs)
}


public func ==(lhs: Date, rhs: Date) -> Bool {
  if lhs.compare(rhs) == .orderedSame {
    return true
  }
  return false
}

public func <(lhs: Date, rhs: Date) -> Bool {
  if lhs.compare(rhs) == .orderedAscending {
    return true
  }
  return false
}


///////////
///////////
///////////
///////////
///////////

extension TL {
  
  static func getRemoteStatus(_ urlreq: String,  completion:@escaping (Int, String,String,String,String,String,String)->())
  {
    guard let idex = info[urlreq] as? [String:Any], // find it
      let idx = idex["idx"] as? Int else { return }
    let t =  taskRows[idx]
    guard !t.inprogress else { return }
    
    
    let session = URLSession.shared
    let url  = URL(string: urlreq + "/json")!
    let request = URLRequest(url: url)
    t.inprogress = true
    let task = session.dataTask(with: request) {data,response,error in
      t.inprogress = false
      guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil
        else {
          if let httpResponse = response as? HTTPURLResponse {
            let code = httpResponse.statusCode
            print("getRemoteStatus completing with error \( httpResponse.statusCode)")
            DispatchQueue.main.async  {
              completion(code,"\(code)","","","","",urlreq) //fix
            }
          }
          return
      }// guard
      
      /// parse what we got
      if let _d = try? JSONSerialization.jsonObject(with:data!, options: .allowFragments)
        as? [String: Any],
        let d = _d {
        if let t = d ["servertitle"] as? String ,
          let p = d ["description"] as? String ,
          let s = d ["elapsed-secs"] as? String ,
          let v =  d["softwareversion"] as? String  {
          let r = "200"
          completion(200, r,t,s,p,v,urlreq)
          return
        }
      }//parae
    }
    task.resume()
  }
  
}//extension

// MARK:  TaskData  Equatable

public func ==(lhs: TaskData, rhs: TaskData) -> Bool {
  return (lhs.server == rhs.server)
}

public enum TaskSortOrdering: String {
  case status
  case server
  case uptime
  case description
  case name
  case version
}
