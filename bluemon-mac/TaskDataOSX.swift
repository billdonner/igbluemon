//
//  TaskData.swift
//  IGBlueMon
//
//  Created by bill donner on 3/12/17.
//

import AppKit

extension DisplayDecorations {
    
    static let bicon = NSImage(named:"blue-ball")!
    static let ricon = NSImage(named:"red-ball")!
    static let yicon = NSImage(named:"yellow-ball")!
    
    func imageFor()->NSImage {
        switch self {
        case .yellowish: return DisplayDecorations.yicon
        case .blueish: return DisplayDecorations.bicon
        case .reddish: return DisplayDecorations.ricon
        }
    }
    func colorFor()->NSColor {
        switch self {
        case .yellowish: return .yellow
        case .blueish: return .blue
        case .reddish: return .red
        }
    }
}

