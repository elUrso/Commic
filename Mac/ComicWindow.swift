//
//  ComicWindow.swift
//  Commic
//
//  Created by Vitor Silva on 15/02/21.
//

import Cocoa

class ComicWindow: NSWindow {

    @IBOutlet weak var comicWindowController: ComicWindowController!
    
    override func keyDown(with event: NSEvent) {
        comicWindowController.keyDown(with: event)
    }
    

}
