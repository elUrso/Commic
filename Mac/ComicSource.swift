//
//  CommicSource.swift
//  Commic
//
//  Created by Vitor Silva on 15/02/21.
//

import Cocoa

protocol ComicSource: AnyObject {
    func name() -> String
    func numberOfPages() -> Int
    func page(at: Int) -> NSImage
    func hasPage(at: Int) -> Bool
    func onPageLoaded(at: Int, completion handler: @escaping ()->())
}
