import SwiftUI

public struct CalendarView: View {
    let presenter: Presenter
    @ObservedObject var observer: Observer
    var viewModel: ViewModel { presenter.viewModel }
    
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now),
        startOfWeek: Weekday
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
    ) {
        self.presenter = Presenter(month: month, year: year, startOfWeek: startOfWeek)
        self.observer = Observer(presenter: presenter)
        presenter.scene = observer
    }
    
    public var body: some View {
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            weekdayLabels
            monthCells
        }
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
                        Color.accentColor.opacity(0.5)
                    }
                    
                    if date.isToday {
                        Circle()
                            .fill(.red)
                            .opacity(0.5)
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
        CalendarView(month: 12, year: 2023, startOfWeek: .sunday)
    }
}
