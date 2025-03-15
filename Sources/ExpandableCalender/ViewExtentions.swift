//
//  ViewExtentions.swift
//  ExpandableCalender
//
//  Created by Bennet Freigang on 10.03.25.
//

import SwiftUI

class CalendarState: ObservableObject {
    @Published var dragProgress: CGFloat = 0  // Wert zwischen 0 und 1
}

struct ExpandableCalendar: ViewModifier {
    @StateObject private var calendarState = CalendarState()
    @State var selection: Date = .now
    
    init(selectedDate: Binding<Date>) {
        _selection = State(initialValue: selectedDate.wrappedValue)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Color.gray
                .opacity(Double(calendarState.dragProgress) * 0.2)
                .ignoresSafeArea()
                .animation(.easeInOut, value: calendarState.dragProgress)
            
            content
        }
        .overlay(alignment: .top) {
            ExpandableCalender(selection: $selection, calendarState: calendarState)
        }
    }
}

extension View {
    public func calendar(selection: Binding<Date>) -> some View {
        modifier(ExpandableCalendar(selectedDate: selection))
    }
}
