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
        monthView()
            .dragGesture(directions: [.left, .right]) { swipe in
                print(swipe)
            } onEnd: { swipe in
                switch swipe {
                case .left:
                    observer.perform(action: .didLast)
                case .right:
                    observer.perform(action: .didNext)
                case .down, .up:
                    break
                }
            }
    }
    
    @ViewBuilder
    var titleStack: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                observer.perform(action: .didLast)
            } label: {
                Image(systemName: "arrowshape.left.fill")
            }
            Spacer()
            Text(viewModel.month)
                .onTapGesture {
                    observer.perform(action: .didTapToday)
                }
            Spacer()
            Button {
                observer.perform(action: .didNext)
            } label: {
                Image(systemName: "arrowshape.right.fill")
            }
        }
        .font(titleFont)
    }
    
    @ViewBuilder
    func monthView() -> some View {
        VStack(alignment: .center, spacing: 8) {
            titleStack
            TabView {
                MonthView(
                    weekdays: viewModel.weekdays,
                    dates: viewModel.dates,
                    labelFont: labelFont,
                    dayFont: dayFont,
                    todayView: todayView,
                    weekdayLabelsBackground: weekdayLabelsBackground,
                    weekendBackground: weekendBackground) { date in
                        observer.perform(action: .didTap(date))
                    }
                    .contentShape(Rectangle())
                    .id(viewModel.month)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.linear, value: viewModel.month)
            .transition(.opacity)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(month: 12, year: 2023, startOfWeek: .sunday, titleFont: .title3, labelFont: .body, dayFont: .caption)
    }
}
