import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasReactions: Bool
    let action: () -> Void
    
    private var calendar = Calendar.current
    
    init(date: Date, isSelected: Bool, isCurrentMonth: Bool, hasReactions: Bool, action: @escaping () -> Void) {
        self.date = date
        self.isSelected = isSelected
        self.isCurrentMonth = isCurrentMonth
        self.hasReactions = hasReactions
        self.action = action
    }
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColors.primaryBlue : Color.clear)
                    .frame(height: 40)
                
                Text("\(dayNumber)")
                    .font(.ibmPlexMono(14, weight: isSelected ? .bold : .medium))
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? AppColors.textPrimary :
                        AppColors.textSecondary.opacity(0.4)
                    )
                
                if hasReactions && !isSelected {
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 4, height: 4)
                        .offset(y: 12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}