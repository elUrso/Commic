//
//  ComicWindowController.swift
//  Commic
//
//  Created by Vitor Silva on 15/02/21.
//

import Cocoa

class ComicWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var currentPage = 0
    weak var source: ComicSource! {
        didSet {
            if source != nil {
                showPage()
                window?.title = "\(source.name()): \(currentPage+1)/\(source.numberOfPages())"
            }
        }
    }
    
    func showPage() {
        self.imageView.image = nil
        let target = currentPage
        progressIndicator.startAnimation(nil)
        source.onPageLoaded(at: target) {
            DispatchQueue.main.async {
                if self.currentPage == target {
                    self.progressIndicator.stopAnimation(nil)
                    self.imageView.image = self.source.page(at: target)
                    self.window?.title = "\(self.source.name()): \(self.currentPage+1)/\(self.source.numberOfPages())"
                }
            }
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override var acceptsFirstResponder: Bool {
        true
    }
    
    override func keyDown(with event: NSEvent) {
        if source == nil {
            return
        }
        
        switch event.keyCode {
        case 123 where currentPage > 0: // left
            currentPage -= 1
        case 124 where currentPage+1 < source.numberOfPages(): // right
            currentPage += 1
        default:
            return
        }
        
        showPage()
    }
    
    func windowWillClose(_ notification: Notification) {
        (document as! NSDocument).close()
    }
}
