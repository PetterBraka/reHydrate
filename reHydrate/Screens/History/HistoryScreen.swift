//
//  HistoryScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Charts
import HistoryPresentationInterface
import PresentationKit
import EngineKit

struct HistoryScreen: View {
    @ObservedObject var observer: HistoryScreenObservable
    @State var contentHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                toolbar
                content
                    .getHeight($contentHeight)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .onAppear {
                observer.perform(action: .didAppear)
            }
        }
        .font(.brandBody)
    }
    
    @ViewBuilder
    var toolbar: some View {
        CustomToolbar {
            Text(historyTitle)
                .foregroundStyle(Color.label)
        } leadingButton: {
            Button {
                observer.perform(action: .didTapBack)
            } label: {
                HStack {
                    Image.back
                    Text("Back")
                }
            }
            .foregroundColor(.button)
            .padding(.leading, 24)
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(alignment: .center, spacing: 8) {
            let rangeBinding = Binding {
                observer.viewModel.range
            } set: { newRange in
                observer.perform(action: .didSelectRange(newRange))
            }
            Picker("", selection: rangeBinding) {
                ForEach(observer.viewModel.rangeOptions) {
                    Text($0.rawValue)
                        .tag($0)
                        .foregroundStyle(Color.label)
                }
            }
            .pickerStyle(.segmented)
            chart
                .frame(height: contentHeight / 3)
                .border(.black)
            Spacer()
        }
    }
    
    @ViewBuilder
    var chart: some View {
        Chart(observer.viewModel.dates, id: \.self) { date in
            let xString = "Goal"
            let vString = "Consumed"
            let dateString = observer.viewModel.range.formatter.string(from: date)
            let xPoint: PlottableValue = .value("Date", dateString)
            if let day = observer.viewModel.days.first(where: {
                dateString == observer.viewModel.range.formatter.string(from: $0.date)
            }) {
                LineMark(x: xPoint, y: .value(xString, day.goal))
                    .foregroundStyle(.green.opacity(0.5))
                switch observer.viewModel.chart {
                case .bar:
                    BarMark(x: xPoint, y: .value(vString, day.consumed))
                case .line:
                    LineMark(x: xPoint, y: .value(vString, day.consumed))
                case .plot:
                    PointMark(x: xPoint, y: .value(vString, day.consumed))
                }
            } else {
                switch observer.viewModel.chart {
                case .bar:
                    BarMark(x: xPoint, y: .value(vString, 0))
                case .line:
                    LineMark(x: xPoint, y: .value(vString, 0))
                case .plot:
                    PointMark(x: xPoint, y: .value(vString, 0))
                }
            }
        }
    }
}

// MARK: - Strings
extension HistoryScreen {
    var historyTitle: String {
        LocalizedString("ui.history.title", value: "History", comment: "The title of the history screen.")
    }
    
    var backButtonTitle: String {
        LocalizedString("ui.history.back", value: "Back", comment: "The back button in the history screen")
    }
}

#Preview {
    SceneFactory.shared.makeHistoryScreen()
}
