import SwiftUI

struct BrandColors {
    static let smartBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let techGreen = Color(red: 0.1, green: 0.8, blue: 0.4)
    static let energyOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let deepSpace = Color(red: 0.08, green: 0.12, blue: 0.18)
    static let lightSpace = Color(red: 0.98, green: 0.99, blue: 1.0)
    
    struct Background {
        static let primary = Color(.controlBackgroundColor)
        static let secondary = Color(.textBackgroundColor)
        static let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(.controlBackgroundColor),
                Color(.controlBackgroundColor).opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    struct Text {
        static let primary = Color(.labelColor)
        static let secondary = Color(.secondaryLabelColor)
        static let tertiary = Color(.tertiaryLabelColor)
    }
    
    struct Surface {
        static let elevated = Color(.controlBackgroundColor)
        static let card = Color(.textBackgroundColor)
        static let glass = Color(.controlBackgroundColor).opacity(0.7)
    }
    
    struct Border {
        static let primary = Color(.separatorColor)
        static let secondary = Color(.quaternaryLabelColor)
    }
    
    struct Status {
        static let online = techGreen
        static let offline = Color(.systemRed)
        static let warning = energyOrange
        static let info = smartBlue
    }
}

extension Color {
    static let brandPrimary = BrandColors.smartBlue
    static let brandSecondary = BrandColors.techGreen
    static let brandAccent = BrandColors.energyOrange
} 