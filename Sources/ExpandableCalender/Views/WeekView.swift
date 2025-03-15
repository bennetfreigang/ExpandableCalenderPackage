//
//  WeekView.swift
//  ExpandableCalender
//
//  Created by Bennet Freigang on 03.03.25.
//

import SwiftUI

struct WeekView: View {
    let week: Week
    let dragPosition: CGFloat
    let hideDifferentMonth: Bool
    
    @Binding var selectedDate: Date
    
    init(
        week: Week,
        selectedDate: Binding<Date>,
        dragPosition: CGFloat,
        hideDifferentMonth: Bool = false
    ) {
        self.week = week
        self.dragPosition = dragPosition
        self.hideDifferentMonth = hideDifferentMonth
        _selectedDate = selectedDate
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(week.days, id: \.self) { date in
                DayView(date: date, selectedDate: $selectedDate)
                    .opacity(isDayVisible(for: date) ? 1 : (1 - dragPosition))
                    .frame(maxWidth: .infinity)
                
                if week.days.last != date {
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func isDayVisible(for date: Date) -> Bool {
        guard hideDifferentMonth else { return true }
        
        switch week.order {
        case .previous, .current:
            guard let last = week.days.last else { return true }
            return Calendar.isSameMonth(date, last)
        case .next:
            guard let first = week.days.first else { return true }
            return Calendar.isSameMonth(date, first)
        }
    }
}
