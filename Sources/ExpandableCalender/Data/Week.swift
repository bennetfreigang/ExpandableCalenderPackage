//
//  Week.swift
//  ExpandableCalender
//
//  Created by Bennet Freigang on 03.03.25.
//

import Foundation

struct Week: Hashable, Identifiable {
    let id: String
    let days: [Date]
    let order: Order
    
    init(days: [Date], order: Order) {
        self.id = Calendar.weekAndYear(from: days.last ?? Date())
        self.days = days
        self.order = order
    }
    
    enum Order {
        case previous, current, next
    }
}

extension Week: Equatable {
    static func ==(lhs: Week, rhs: Week) -> Bool {
        lhs.id == rhs.id
    }
}

extension Week {
    static let current = Week(days: Calendar.currentWeek(from: Calendar.nearestMonday(from: Date())), order: .current)
}
