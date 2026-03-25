import SwiftUI

struct OnboardingStep4View: View {

    @ObservedObject var viewModel: OnboardingViewModel

    @State private var isMetric: Bool = true
    @State private var heightCm: Int = 170
    @State private var weightKg: Int = 70
    @State private var heightFt: Int = 5
    @State private var heightIn: Int = 7
    @State private var weightLb: Int = 154

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
                    Text("4 of 7")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                // Title
                Text("Height & weight")
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

                Spacer().frame(height: 32)

                // Imperial / Metric toggle
                HStack {
                    Spacer()
                    Text("Imperial")
                        .font(isMetric ? AppConstants.Typography.mealSubtitle : .system(size: 17, weight: .semibold))
                        .foregroundStyle(isMetric ? AppConstants.Colors.textSecondary : AppConstants.Colors.textPrimary)
                    Toggle("", isOn: $isMetric)
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .frame(width: 51)
                    Text("Metric")
                        .font(isMetric ? .system(size: 17, weight: .semibold) : AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(isMetric ? AppConstants.Colors.textPrimary : AppConstants.Colors.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 24)

                // Pickers
                if isMetric {
                    HStack(alignment: .top) {
                        VStack(spacing: 4) {
                            Text("Height")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AppConstants.Colors.textPrimary)
                            Picker("", selection: $heightCm) {
                                ForEach(100...220, id: \.self) { cm in
                                    Text("\(cm) cm").tag(cm)
                                }
                            }
                            .pickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                        }

                        VStack(spacing: 4) {
                            Text("Weight")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AppConstants.Colors.textPrimary)
                            Picker("", selection: $weightKg) {
                                ForEach(30...200, id: \.self) { kg in
                                    Text("\(kg) kg").tag(kg)
                                }
                            }
                            .pickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    HStack(alignment: .top) {
                        VStack(spacing: 4) {
                            Text("Height")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AppConstants.Colors.textPrimary)
                            HStack(spacing: 0) {
                                Picker("", selection: $heightFt) {
                                    ForEach(3...8, id: \.self) { ft in
                                        Text("\(ft) ft").tag(ft)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)

                                Picker("", selection: $heightIn) {
                                    ForEach(0...11, id: \.self) { inch in
                                        Text("\(inch) in").tag(inch)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                            }
                        }

                        VStack(spacing: 4) {
                            Text("Weight")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AppConstants.Colors.textPrimary)
                            Picker("", selection: $weightLb) {
                                ForEach(66...440, id: \.self) { lb in
                                    Text("\(lb) lb").tag(lb)
                                }
                            }
                            .pickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    viewModel.skip()
                } label: {
                    Text("Skip for now")
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.plain)

                Button {
                    if isMetric {
                        viewModel.weightKg = String(weightKg)
                        viewModel.heightCm = String(heightCm)
                    } else {
                        let totalInches = (heightFt * 12) + heightIn
                        let cm = Int(Double(totalInches) * 2.54)
                        let kg = Int(Double(weightLb) / 2.205)
                        viewModel.weightKg = String(kg)
                        viewModel.heightCm = String(cm)
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
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = OnboardingViewModel()
    OnboardingStep4View(viewModel: vm)
}
