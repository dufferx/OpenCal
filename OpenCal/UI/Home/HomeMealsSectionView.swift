import SwiftUI

struct HomeMealsSectionView: View {
    let entries: [FoodEntry]
    let onDelete: (UUID) async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Meals")
                .font(AppConstants.Typography.mealTitle)
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .padding(.horizontal, AppConstants.Spacing.screenHorizontal)

            if entries.isEmpty {
                ContentUnavailableView("No meals yet", systemImage: "fork.knife",
                    description: Text("Tap + to add your first meal of the day"))
                    .padding(.vertical, 16)
            } else {
                List {
                    ForEach(entries) { entry in
                        MealCard(entry: entry, onSaveToLibrary: nil)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task { await onDelete(entry.id) }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .frame(height: CGFloat(entries.count) * (AppConstants.Spacing.mealCardHeight + 12))
            }
        }
    }
}
