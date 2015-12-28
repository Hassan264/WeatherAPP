//
//  Extensions.swift
//  weather
//
//  Created by Hassan Almasri on 26/12/2015.
//  Copyright © 2015 Hassan Almasri. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject(object: AnyObject) {
        for (index, obj) in self.enumerate() {
            if (obj as! AnyObject) === object {
                self.removeAtIndex(index)
                break
            }
        }
    }
}