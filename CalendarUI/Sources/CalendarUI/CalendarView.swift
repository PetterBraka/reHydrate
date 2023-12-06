import SwiftUI

public struct CalendarView: View {
    let presenter: Presenter
    @ObservedObject var observer: Observer
    var viewModel: ViewModel { presenter.viewModel }
    
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now)
    ) {
        self.presenter = Presenter(month: month, year: year)
        self.observer = Observer(presenter: presenter)
        presenter.scene = observer
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {
                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                ForEach(viewModel.dates.chunked(into: 7), id: \.self) { week in
                    GridRow {
                        ForEach(week, id: \.date) { date in
                            cell(for: date)
                        }
                    }
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
        CalendarView(month: 12, year: 2023)
    }
}
