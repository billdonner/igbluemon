//
//  TaskData
//  IGBlueMon
//
//  Created by bill donner on 3/12/17.
//

import UIKit

extension DisplayDecorations {
    static let bicon = UIImage(named:"blue-ball")!
    static let ricon = UIImage(named:"red-ball")!
    static let yicon = UIImage(named:"yellow-ball")!
    func imageFor()->UIImage {
        switch self {
        case .yellowish: return DisplayDecorations.yicon
        case .blueish: return DisplayDecorations.bicon
        case .reddish: return DisplayDecorations.ricon
        }
    }
    
    
    static let cy = UIColor(colorLiteralRed: 0.2, green: 0, blue: 0.2, alpha: 0.7)
    static let cr = UIColor(colorLiteralRed: 0.2, green: 0, blue: 0, alpha: 0.7)
    static let cg = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.2, alpha: 0.7)
    
    func colorFor()->UIColor {
        switch self {
        case .yellowish: return DisplayDecorations.cy
        case .blueish:   return DisplayDecorations.cg
        case .reddish:   return DisplayDecorations.cr
        }
    }
}

