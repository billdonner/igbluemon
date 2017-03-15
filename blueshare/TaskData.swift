import Foundation

typealias ServerInfo = [String:String]

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


///////////
///////////
///////////
///////////
///////////


/// ItemData is safely copied out to callers  so the task schedule can be private
public struct ItemData  {
    
    var status: String
    var server: String
    var name: String
    var uptime: String
    var description : String
    var version : String
    var inprogress : Bool
    var downcount: Int
    var statusEndpoint: String
    
    var displayDecorations : DisplayDecorations
    
    init(_ td:TaskData){
        self.status = td.status
        self.server = td.server
        self.downcount = td.downcount
        self.name = td.name
        self.uptime = td.uptime
        self.description = td.description
        self.version = td.version
        self.inprogress = td.inprogress
        self.displayDecorations = td.displayDecorations
        
        self.statusEndpoint = td.statusEndpoint
      
    }
    
    
    var paddedUptime: String {
        let str = uptime.components(separatedBy: ".").first!
        if  let xx = Double(str as String) {
            if xx > 0 {
                let paddedStr = str.leftPadding(toLength:7,  withPad: "0" )
                return paddedStr
            }
        }
        
        return "9999999"
    }
}


///////////
///////////
///////////
///////////
///////////

/// each task/row in the class list is a TaskData class instance that is allocated once and updated from all directions

class  TaskData {
    
    var status: String
    var server: String
    
    var statusEndpoint: String
    var name: String
    var uptime: String
    var description : String
    var version : String
    var inprogress = false
    var downcount: Int
    var secsBetweenBadPolls: TimeInterval = 120
    var secsBetweenGoodPolls: TimeInterval = 10
    var selfidx: Int
    var lastResponse:[String:Any]
    var displayDecorations : DisplayDecorations
    
    init(idx: Int, status: String, name: String, server: String, statusEndpoint: String, uptime: String, description: String, version:String, downcount: Int, ish: DisplayDecorations, last:[String:Any]) {
        
        self.selfidx = idx
        self.status = status
        self.name = name
        self.server = server
        self.statusEndpoint = statusEndpoint
        self.uptime = uptime
        self.version = version
        self.description = description
        self.displayDecorations  = ish
        self.lastResponse = last
        self.downcount = downcount
    }
    func dictFor() -> [String:Any]{
        return [
            "selfidx": selfidx,
         "status": status,
          "name": name,
           "server": server,
            "statusEndpoint": statusEndpoint,
             "version": version,
              "uptime": uptime,
               "description": description,
                "displayDecorations": displayDecorations,
                 "lastResponse": lastResponse,
                  "downcount": downcount]
    }
    
 
    
    public var debugDescription: String {
        return uptime + " " + "\(server)" + " status: \(status)"
    }
}


///////////
///////////
///////////
///////////
///////////

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

// MARK:  TaskData  Equatable

func ==(lhs: TaskData, rhs: TaskData) -> Bool {
    return (lhs.server == rhs.server)
}


