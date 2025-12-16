import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    let completionDate: Date
    let isRepeatSession: Bool
    let completionCount: Int
    
    let onReturnHome: () -> Void
    let onRepeatPractice: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter
    }()
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 40) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    VStack(spacing: 16) {
                        Text("Day Complete")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Text("You let go of the day. Everything else can wait until morning.")
                            .font(.ubuntu(18, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ColorTheme.primaryYellow)
                            Text("Today's practice completed.")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        
                        Text(dateFormatter.string(from: completionDate))
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.textLight)
                        
                        if completionCount > 1 {
                            Text("Practice repeated \(ordinalString(completionCount)) time today.")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.textLight)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorTheme.primaryYellow.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ColorTheme.primaryYellow.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        onReturnHome()
                        dismiss()
                    }) {
                        Text("Return to Home")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorTheme.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Button(action: {
                        onRepeatPractice()
                        dismiss()
                    }) {
                        Text("Practice Again")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(ColorTheme.lightBlue.opacity(0.2))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func ordinalString(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)th"
    }
}

#Preview {
    CompletionView(
        completionDate: Date(),
        isRepeatSession: false,
        completionCount: 1,
        onReturnHome: {},
        onRepeatPractice: {}
    )
}
