//
//  ComicImageView.swift
//  Commic
//
//  Created by Vitor Silva on 15/02/21.
//

import Cocoa

class ComicView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        nextResponder?.keyDown(with: event)
    }
}
