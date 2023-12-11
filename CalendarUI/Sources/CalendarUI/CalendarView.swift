import SwiftUI

public struct CalendarView<TodayView: View,
                           WeekdayLabelsBackground: View,
                           WeekendBackground: View>: View {
    let presenter: Presenter
    @ObservedObject var observer: Observer
    var viewModel: ViewModel { presenter.viewModel }
    
    let titleFont: Font
    let labelFont: Font
    let dayFont: Font
    
    let todayView: (() -> TodayView)?
    let weekdayLabelsBackground: (() -> WeekdayLabelsBackground)?
    let weekendBackground: (() -> WeekendBackground)?
    
    var transition: AsymmetricTransition<MoveTransition, MoveTransition> {
        switch viewModel.swipeDirection {
        case .left:
            AsymmetricTransition(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .right:
            AsymmetricTransition(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        case .up, .down, .none:
            AsymmetricTransition(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        }
    }
    
    init(
        month: Int,
        year: Int,
        startOfWeek: Weekday,
        titleFont: Font,
        labelFont: Font,
        dayFont: Font,
        todayView: (() -> TodayView)?,
        weekdayLabelsBackground: (() -> WeekdayLabelsBackground)?,
        weekendBackground: (() -> WeekendBackground)?
    ) {
        self.presenter = Presenter(month: month, year: year, startOfWeek: startOfWeek)
        self.observer = Observer(presenter: presenter)
        self.titleFont = titleFont
        self.labelFont = labelFont
        self.dayFont = dayFont
        
        self.todayView = todayView
        self.weekdayLabelsBackground = weekdayLabelsBackground
        self.weekendBackground = weekendBackground
        
        presenter.scene = observer
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(viewModel.month)
                .font(titleFont)
            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                weekdayLabels
                    .font(labelFont)
                monthCells
                    .font(dayFont)
            }
        }
        .contentShape(Rectangle())
        .id(viewModel.month)
        .transition(transition)
        .animation(.spring, value: viewModel.month)
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    switch value.direction {
                    case .left:
                        presenter.perform(action: .didSwipeLeft)
                    case .right:
                        presenter.perform(action: .didSwipeRight)
                    case .up, .down, .none:
                        break
                    }
                }
        )
    }
    
    @ViewBuilder
    var weekdayLabels: some View {
        GridRow {
            ForEach(viewModel.weekdays, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background {
            if let weekdayLabelsBackground {
                weekdayLabelsBackground()
            } else {
                Color.accentColor.opacity(0.75)
            }
        }
    }
    
    @ViewBuilder
    var monthCells: some View {
        ForEach(viewModel.dates.chunked(into: 7), id: \.self) { week in
            GridRow {
                ForEach(week, id: \.date) { date in
                    cell(for: date)
                }
            }
        }
    }
    
    @ViewBuilder
    func cell(for date: ViewModel.CalendarDate) -> some View {
        let day = Calendar.current.component(.day, from: date.date)
        Text("\(day)")
            .opacity(date.isThisMonth ? 1.0 : 0.5)
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    if !date.isWeekday {
                        if let weekendBackground {
                            weekendBackground()
                        } else {
                            Color.accentColor
                                .opacity(0.25)
                        }
                    } else {
                        Color.white
                    }
                    
                    if date.isToday {
                        if let todayView {
                            todayView()
                        } else {
                            Circle()
                                .fill(.red)
                                .opacity(0.2)
                        }
                    }
                }
            }
            .onTapGesture {
                observer.perform(action: .didTap(date))
            }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(month: 12, year: 2023, startOfWeek: .sunday, titleFont: .title3, labelFont: .body, dayFont: .caption)
    }
}
