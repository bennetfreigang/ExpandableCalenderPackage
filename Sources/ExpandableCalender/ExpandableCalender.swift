// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct ExpandableCalender: View {
    @State private var selection: Date? = .now
    @State private var title: String = Calendar.monthAndYear(from: .now)
    @State private var focusedWeek: Week = .current
    @State private var calendarType: CalendarType = .week
    @State private var isDragging: Bool = false
    
    @State private var initialDragOffset: CGFloat? = nil
    @State private var verticalDragOffset: CGFloat = .zero
    
    @ObservedObject var calendarState: CalendarState
    
    private let symbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    enum CalendarType {
        case week, month
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray.opacity(0.2).ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(title).font(.title2.bold())
                    Spacer()
                }
                .padding(.bottom)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                HStack {
                    ForEach(symbols, id: \.self) { symbol in
                        Text(symbol)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)

                        if symbol != symbols.last {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    switch calendarType {
                    case .week:
                        WeekCalendarView(
                            $title,
                            selection: $selection,
                            focused: $focusedWeek,
                            isDragging: isDragging
                        )
                    case .month:
                        MonthCalendarView(
                            $title,
                            selection: $selection,
                            focused: $focusedWeek,
                            isDragging: isDragging,
                            dragProgress: calendarState.dragProgress
                        )
                    }
                }
                .frame(height: Constants.dayHeight + verticalDragOffset)
                .clipped()
                
                Capsule()
                    .fill(.gray.mix(with: .secondary, by: 0.6))
                    .frame(width: 40, height: 4)
                    .padding(.bottom, 6)
            }
            .background(
                UnevenRoundedRectangle(
                    cornerRadii: .init(bottomLeading: 16, bottomTrailing: 16)
                )
                .fill(.background)
                .ignoresSafeArea()
            )
            .onChange(of: selection) { oldValue, newValue in
                guard let newValue else { return }
                title = Calendar.monthAndYear(from: newValue)
            }
            .gesture(
                DragGesture(minimumDistance: .zero)
                    .onChanged { value in
                        isDragging = true
                        calendarType = verticalDragOffset == 0 ? .week : .month
                        
                        if initialDragOffset == nil {
                            initialDragOffset = verticalDragOffset
                        }
                        
                        verticalDragOffset = max(
                            .zero,
                            min(
                                (initialDragOffset ?? 0) + value.translation.height,
                                Constants.monthHeight - Constants.dayHeight
                            )
                        )
                        
                        calendarState.dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
                    }
                    .onEnded { value in
                        isDragging = false
                        initialDragOffset = nil
                        
                        withAnimation {
                            switch calendarType {
                            case .week:
                                if verticalDragOffset > Constants.monthHeight / 3 {
                                    verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                                } else {
                                    verticalDragOffset = 0
                                }
                            case .month:
                                if verticalDragOffset < Constants.monthHeight / 3 {
                                    verticalDragOffset = 0
                                } else {
                                    verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                                }
                            }
                            
                            calendarState.dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
                        } completion: {
                            calendarType = verticalDragOffset == 0 ? .week : .month
                        }
                    }
            )
        }
    }
}

#Preview {
    ExpandableCalender(calendarState: CalendarState())
}
