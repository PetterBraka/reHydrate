import SwiftUI

public struct CalendarView: View {
    var dates: [Date] = []
    let month: Int
    let year: Int
    
    public init(
        month: Int = Calendar.current.component(.month, from: .now),
        year: Int = Calendar.current.component(.year, from: .now)
    ) {
        self.month = month
        self.year = year
        
        let calendar = Calendar.current
        let startOfMonth = getStartOfMonth(month: month, year: year)
        let endOfMonth = getEndOfMonth(from: startOfMonth)
        
        let daysToAddBefore = getDaysToAddBefore(startOfMonth)
        let daysToAddAfter = getDaysToAddAfter(endOfMonth)
        let firstDate = calendar.date(byAdding: .day, value: -daysToAddBefore, to: startOfMonth)!
        let lastDate = calendar.date(byAdding: .day, value: daysToAddAfter, to: endOfMonth)!
        let dates = generateDates(from: firstDate, to: lastDate)
        self.dates = dates
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Grid {
                GridRow {
                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            let gridItem = GridItem(.flexible(), spacing: 0, alignment: .center)
            LazyVGrid(columns: Array(repeating: gridItem, count: 7)) {
                ForEach(dates, id: \.self) { date in
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    Text("\(day)")
                        .opacity(isDateInCurrentMonth(date) ? 1.0 : 0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(4)
                        .background {
                            let day = calendar.component(.day, from: date)
                            let month = calendar.component(.month, from: date)
                            let year = calendar.component(.year, from: date)
                            let TodayDay = calendar.component(.day, from: .now)
                            let TodayMonth = calendar.component(.month, from: .now)
                            let TodayYear = calendar.component(.year, from: .now)
                            if day == TodayDay,
                               month == TodayMonth,
                               year == TodayYear {
                                Circle()
                                    .fill(.red)
                                    .opacity(0.5)
                            }
                        }
                }
            }
        }
    }
    
    // Helper function to get the start of the month
    private func getStartOfMonth(month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components) ?? Date()
    }
    
    // Helper function to get the end of the month
    private func getEndOfMonth(from date: Date) -> Date {
        Calendar.current.date(byAdding: .init(month: 1, day: -1), to: date)!
    }
    
    // Helper function to get the number of days to add before the first day of the month
    func getDaysToAddBefore(_ startOfMonth: Date) -> Int {
        let calendar = Calendar.current
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        return (startWeekday - calendar.firstWeekday + 7) % 7
    }
    
    // Helper function to get the number of days to add after the last day of the month
    func getDaysToAddAfter(_ endOfMonth: Date) -> Int {
        let calendar = Calendar.current
        let daysToAddAfter = calendar.component(.weekday, from: endOfMonth)
        return (daysToAddAfter == 7) ? 6 : (7 - daysToAddAfter)
    }
    
    // Helper function to generate an array of dates within the current month
    private func generateDates(from start: Date, to end: Date) -> [Date] {
        var currentDate = start
        var resultDates: [Date] = []
        
        while currentDate <= end {
            resultDates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return resultDates
    }
    
    // Helper function to check if a date is in the same month as the displayed month
    private func isDateInCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: date) == month
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(month: 12, year: 2023)
    }
}
