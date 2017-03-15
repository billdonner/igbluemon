import Cocoa
class IGBlueMonViewController: NSViewController {
  
  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var tableView: NSTableView!
  
  let sizeFormatter = ByteCountFormatter()
  var sortOrder = TaskSortOrdering.server
  var sortAscending = true
  var dateFormate : DateFormatter!
  let startdate = Date()
  
  
    func tictoc( ) {
    ///////
    MasterTasks.reloadTaskList(ordering:sortOrder,ascending:sortAscending)
    
    MasterTasks.runScheduler() // once per second
    //////////
    
        
    statusLabel.stringValue = dateFormate.string(from: Date())
    tableView.reloadData()
    
  }
  
  override func viewDidLoad() {
    
    
    // Override point for customization after application launch.

    
    //////////
    
    do { try MasterTasks.setup() } catch { // do something nice looking??
        fatalError("cant setup MasterTasks")
    }
    
    dateFormate = DateFormatter()
    dateFormate!.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    super.viewDidLoad()
    statusLabel.stringValue = "as of \(Date())"
    tableView.target = self
    tableView.doubleAction = #selector(tableViewDoubleClick(_:))
    
    let descriptorStatus = NSSortDescriptor(key: TaskSortOrdering.status.rawValue, ascending: true)
    let descriptorServer = NSSortDescriptor(key: TaskSortOrdering.server.rawValue, ascending: true)
    let descriptorUptime = NSSortDescriptor(key: TaskSortOrdering.uptime.rawValue, ascending: true)
    let descriptorDescription = NSSortDescriptor(key: TaskSortOrdering.description.rawValue, ascending: true)
    
    tableView.tableColumns[0].sortDescriptorPrototype = descriptorStatus
    tableView.tableColumns[1].sortDescriptorPrototype = descriptorServer
    tableView.tableColumns[2].sortDescriptorPrototype = descriptorUptime
    tableView.tableColumns[3].sortDescriptorPrototype = descriptorDescription
    
    //////
    MasterTasks.newTaskList()
    //////
    //dont setup delegates until tasklist is established
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tictoc()
    Timer.scheduledTimer(timeInterval: Double(1.0/MasterTasks.framesPerSecond), target: self,
                         selector: #selector(tictoc), userInfo: nil, repeats: true)
  }
  
  override var representedObject: Any? {
    didSet {
      if (representedObject as? String) != nil {
        ////////////
        MasterTasks.newTaskList()
        /////////////
        reloadFileList()
      }
    }
  }
  
  func reloadFileList() {
    ////////////
    MasterTasks.reloadTaskList(ordering:sortOrder,ascending:sortAscending)
    ///////////////
    //tableView.reloadData()
  }
  
  func updateStatus() {
    
    let text: String
    
    let itemsSelected = tableView.selectedRowIndexes.count
    
    //    if (taskRows == nil) {
    //      text = "No Items"
    //    }
    //    else
    
    if(itemsSelected == 0) {
      text = "\(MasterTasks.tasksCount()) items"
    }
    else {
      text = "\(itemsSelected) of \(MasterTasks.tasksCount()) selected"
    }
    
    statusLabel.stringValue = text
  }
  
  ////// dubl click ///////////
  
  func tableViewDoubleClick(_ sender:AnyObject) {
    // 1
    guard tableView.selectedRow >= 0 else {
      return
    }
    /////////
    let item = MasterTasks.itemData(row:tableView.selectedRow)
    //////////
    //    if item.isFolder { // is folder is hardwired false
    //      representedObject = item.server as Any
    //    } else
    //
    //
    //    {
    let remote = URL(string:item.server )!
    print("trying to open \(remote)")
    NSWorkspace.shared().open(remote)
    //}
    // }
    
  }
}


extension IGBlueMonViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return MasterTasks.tasksCount()
  }
  
  func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
    guard let sortDescriptor = tableView.sortDescriptors.first else {
      return
    }
    
    if let order = TaskSortOrdering(rawValue: sortDescriptor.key!) {
      sortOrder = order
      sortAscending = sortDescriptor.ascending
      reloadFileList()
    }
  }
  
}

extension IGBlueMonViewController: NSTableViewDelegate {
  
  fileprivate enum CellIdentifiers {
    static let StatusCell = "StatusCellID"
    static let ServerCell = "ServerCellID"
    static let UptimeCell = "UptimeCellID"
    static let DescriptionCell = "DescriptionCellID"
    static let VersionCell = "VersionCellID"
    static let NameCell = "NameCellID"
  }
  
  
  ///// contents of cells tweaked in here //////////////
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
    var image: NSImage?
    var text: String = ""
    var cellIdentifier: String = ""
    
    ///////
    let item = MasterTasks.itemData(row:row)
    ///////
    if tableColumn == tableView.tableColumns[0] {
      image = item.displayDecorations.imageFor()
      text = item.status
      cellIdentifier = CellIdentifiers.StatusCell
    }
      
    else if tableColumn == tableView.tableColumns[1] {
      text = item.paddedUptime
      cellIdentifier = CellIdentifiers.UptimeCell
    }
      
    else if tableColumn == tableView.tableColumns[2] {
      text = item.name
      cellIdentifier = CellIdentifiers.NameCell
    }else if tableColumn == tableView.tableColumns[3] {
      text = item.server
      cellIdentifier = CellIdentifiers.ServerCell
    } else if tableColumn == tableView.tableColumns[4] {
      text = item.description
      cellIdentifier = CellIdentifiers.DescriptionCell
    }else if tableColumn == tableView.tableColumns[5] {
      text = item.version
      cellIdentifier = CellIdentifiers.VersionCell
    }
    
    if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      cell.imageView?.image = image ?? nil
      return cell
    }
    return nil
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    updateStatus()
  }
  
}
