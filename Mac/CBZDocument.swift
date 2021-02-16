//
//  CBZDocument.swift
//  Commic
//
//  Created by Vitor Silva on 14/02/21.
//

import Cocoa

class CBZDocument: NSDocument {
    var windowController: ComicWindowController!
    var comic: CBZComic!

    override init() {
        super.init()
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        windowController = ComicWindowController(windowNibName: "ComicWindow")
        windowController.document = self
        windowController.showWindow(self)
        windowController.source = comic
    }

    override func data(ofType typeName: String) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        comic = CBZComic(withData: data, name: self.fileURL?.lastPathComponent ?? "")
        if comic == nil {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
}

