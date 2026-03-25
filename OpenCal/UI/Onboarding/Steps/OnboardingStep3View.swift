import SwiftUI

struct OnboardingStep3View: View {

    @ObservedObject var viewModel: OnboardingViewModel

    private let days: [Int] = Array(1...31)
    private let months: [Int] = Array(1...12)
    private let years: [Int] = {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current - 100)...(current - 13)).reversed()
    }()
    private let monthSymbols = Calendar.current.monthSymbols

    @State private var selectedDay: Int
    @State private var selectedMonth: Int
    @State private var selectedYear: Int

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        let comps = Calendar.current.dateComponents([.day, .month, .year], from: viewModel.birthDate)
        _selectedDay   = State(initialValue: comps.day   ?? 1)
        _selectedMonth = State(initialValue: comps.month ?? 1)
        _selectedYear  = State(initialValue: comps.year  ?? Calendar.current.component(.year, from: Date()) - 25)
    }

    var body: some View {
        ZStack(alignment: .top) {
            AppConstants.Colors.backgroundPrimary
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Back button row
                HStack {
                    Button {
                        viewModel.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppConstants.Colors.textPrimary)
                            .frame(width: 36, height: 36)
                            .glassEffect(.regular, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Go back")
                    Spacer()
                    Text("3 of 7")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                // Title
                Text("When were you born?")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppConstants.Colors.textPrimary)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                // Subtitle
                Text("This will be used to calibrate your custom plan.")
                    .font(AppConstants.Typography.mealSubtitle)
                    .foregroundStyle(AppConstants.Colors.textSecondary)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)

                Spacer()

                // Day | Month | Year pickers
                HStack(spacing: 0) {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(days, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)

                    Picker("Month", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(monthSymbols[month - 1]).tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)

                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                var components = DateComponents()
                components.day   = selectedDay
                components.month = selectedMonth
                components.year  = selectedYear
                if let date = Calendar.current.date(from: components) {
                    viewModel.birthDate = date
                }
                viewModel.advance()
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppConstants.Colors.textPrimary, in: RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = OnboardingViewModel()
    OnboardingStep3View(viewModel: vm)
}
