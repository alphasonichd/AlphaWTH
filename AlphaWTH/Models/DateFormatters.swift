//
//  DateFormatters.swift
//  AlphaWTH
//
//  Created by developer on 20.05.21.
//

import Foundation
import UIKit

class DateFormatters {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.setLocalizedDateFormatFromTemplate("ddMMMM")
        return formatter
    }()
}
