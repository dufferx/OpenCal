import SwiftUI

struct CalendarStripView: View {
    @Binding var selectedDate: Date
    let datesWithLogs: Set<DateComponents>

    private let calendar = Calendar.current

    private let dates: [Date] = {
        let today = Calendar.current.startOfDay(for: .now)
        return (-45...44).compactMap { offset in
            Calendar.current.date(byAdding: .day, value: offset, to: today)
        }
    }()

    // MARK: - Derived

    private var monthYearLabel: String {
        CalendarStripView.monthYearFormatter.string(from: selectedDate)
    }

    private static let monthYearFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM, y"
        return f
    }()

    // MARK: - Helpers

    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func hasLog(for date: Date) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return datesWithLogs.contains(components)
    }

    private func scrollID(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            Text(monthYearLabel)
                .font(AppConstants.Typography.monthLabel)
                .foregroundStyle(AppConstants.Colors.textPrimary)

            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 24) {
                        ForEach(dates, id: \.self) { date in
                            DayCell(
                                date: date,
                                isSelected: isSelected(date),
                                hasLog: hasLog(for: date)
                            ) {
                                withAnimation(.spring()) {
                                    selectedDate = date
                                }
                            }
                            .id(scrollID(for: date))
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    proxy.scrollTo(scrollID(for: selectedDate), anchor: .center)
                }
                .onChange(of: selectedDate) { _, newDate in
                    withAnimation(.spring()) {
                        proxy.scrollTo(scrollID(for: newDate), anchor: .center)
                    }
                }
            }
        }
    }
}

// MARK: - DayCell

private struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasLog: Bool
    let action: () -> Void

    private var dayNumber: String {
        "\(Calendar.current.component(.day, from: date))"
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(AppConstants.Typography.calendarDay)
                    .foregroundStyle(isSelected ? Color.white : AppConstants.Colors.textSecondary)
                    .frame(
                        width: AppConstants.Spacing.calendarDaySize,
                        height: AppConstants.Spacing.calendarDaySize
                    )
                    .background(
                        isSelected
                            ? AppConstants.Colors.textPrimary
                            : AppConstants.Colors.backgroundSecondary
                    )
                    .clipShape(Circle())

                Circle()
                    .fill(AppConstants.Colors.textPrimary)
                    .frame(width: 4, height: 4)
                    .opacity(hasLog ? 1 : 0)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(date, format: .dateTime.weekday(.wide).day().month()))
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var selected = Date()

    let logs: Set<DateComponents> = {
        let cal = Calendar.current
        let today = cal.dateComponents([.year, .month, .day], from: Date())
        let yesterday = cal.dateComponents(
            [.year, .month, .day],
            from: cal.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        )
        return [today, yesterday]
    }()

    CalendarStripView(selectedDate: $selected, datesWithLogs: logs)
        .padding(.vertical)
        .background(AppConstants.Colors.backgroundPrimary)
}
