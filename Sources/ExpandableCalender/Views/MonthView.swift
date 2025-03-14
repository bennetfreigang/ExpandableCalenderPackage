//
//  MonthView.swift
//  ExpandableCalender
//
//  Created by Bennet Freigang on 03.03.25.
//

import SwiftUI

struct MonthView: View {
    let month: Month
    let dragProgress: CGFloat
    
    @Binding var focused: Week
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack(spacing: .zero) {
            ForEach(month.weeks) { week in
                WeekView(week: week, selectedDate: $selectedDate, dragPosition: dragProgress, hideDifferentMonth: true)
                    .opacity(focused == week ? 1 : dragProgress)
                    .frame(height: Constants.monthHeight / CGFloat(month.weeks.count))
            }
        }
    }
}

#Preview {
    MonthView(
        month: .init(from: .now, order: .current),
        dragProgress: 1,
        focused: .constant(.current),
        selectedDate: .constant(nil)
    )
}
