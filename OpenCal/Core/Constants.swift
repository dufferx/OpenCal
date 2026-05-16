import Foundation
import SwiftUI

enum AppConstants {
    enum Keychain {
        static let apiKeyIdentifier = "com.aicalorietracker.apikey"
    }

    enum Defaults {
        static let dailyCalorieGoal: Double = 2000
        static let dailyProteinGoal: Double = 150
        static let dailyCarbsGoal: Double = 200
        static let dailyFatGoal: Double = 65
        static let ageOffset: Int = 25
    }

    // MARK: - Colors
    enum Colors {
        // Backgrounds
        static let backgroundPrimary = Color(hex: "#F6F6F6")
        static let backgroundCard = Color.white
        static let backgroundSecondary = Color(hex: "#E5E5EA")
        // Text
        static let textPrimary = Color(hex: "#000000")
        static let textSecondary = Color(hex: "#8E8E93")
        static let textTertiary = Color(hex: "#AEAEB2")
        // Macro rings
        static let ringFilled = Color(hex: "#000000")
        static let ringTrack = Color(hex: "#E5E5EA")
        // Calorie arc
        static let calorieFilled = Color(hex: "#000000")
        static let calorieTrack = Color(hex: "#D1D1D6")
    }

    // MARK: - Typography
    // All tokens use semantic text styles so they scale with the user's Dynamic Type size.
    // Default pt sizes at the "Large" accessibility size are noted in comments.
    enum Typography {
        static let greeting    = Font.subheadline                                 // 15pt regular
        static let userName    = Font.system(.title, weight: .bold)               // 28pt bold
        static let monthLabel  = Font.system(.subheadline, weight: .medium)       // 15pt medium
        static let calorieCount = Font.system(.largeTitle, weight: .bold)         // 34pt bold
        static let calorieUnit = Font.title3                                      // 20pt regular
        static let calorieGoal = Font.footnote                                    // 13pt regular
        static let macroValue  = Font.system(.title3, weight: .semibold)          // 20pt semibold
        static let macroGoal   = Font.caption                                     // 12pt regular
        static let macroLabel  = Font.system(.subheadline, weight: .semibold)     // 15pt semibold
        static let mealTitle   = Font.system(.headline, weight: .bold)            // 17pt bold
        static let mealSubtitle = Font.subheadline                                // 15pt regular
        static let calendarDay = Font.system(.callout, weight: .medium)           // 16pt medium
    }

    // MARK: - Spacing & Layout
    enum Spacing {
        static let screenHorizontal: CGFloat = 21
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let macroCardWidth: CGFloat = 110
        static let macroCardHeight: CGFloat = 174
        static let macroRingSize: CGFloat = 74
        static let macroRingLineWidth: CGFloat = 6
        static let calorieArcWidth: CGFloat = 248
        static let calorieArcHeight: CGFloat = 124
        static let calorieArcLineWidth: CGFloat = 18
        static let calendarDaySize: CGFloat = 34
        static let avatarSize: CGFloat = 50
        static let profileAvatarSize: CGFloat = 100
        static let sectionSpacing: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28
        static let gridItemSpacing: CGFloat = 16
        static let textFieldPadding: CGFloat = 14
        static let providerSpacing: CGFloat = 12
        static let labelSpacing: CGFloat = 8
        static let formRowIndent: CGFloat = 56
        static let mealCardHeight: CGFloat = 122
        static let mealImageSize: CGFloat = 110
        static let mealImageCornerRadius: CGFloat = 16
        static let kcalBadgeCornerRadius: CGFloat = 12
    }

    // MARK: - Shadow
    enum Shadow {
        static let cardColor = Color.black.opacity(0.25)
        static let cardRadius: CGFloat = 4
        static let cardX: CGFloat = 0
        static let cardY: CGFloat = 2
    }

    // MARK: - Liquid Glass (Tab Bar)
    enum Glass {
        static let blurRadius: CGFloat = 6
        static let tabBarCornerRadius: CGFloat = 30
    }
}
