//
//  Utilities.swift
//  HugeClock
//
//  Created by Niharika on 15/04/23.
//

import Foundation
import MapKit

extension Optional where Wrapped == String {
    func isEmptyOrNil() -> Bool{
        if let string = self, string.isEmpty == false {
            return false
        }
        return true
    }
}


