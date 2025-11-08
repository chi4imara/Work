import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var eventStore: EventStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                VStack(spacing: 24) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            Text("Filter Events")
                                .font(FontManager.title)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Select event types to display")
                                .font(FontManager.body)
                                .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 50)
                        
                        VStack(spacing: 16) {
                            ForEach(EventType.allCases, id: \.self) { eventType in
                                FilterTypeRow(
                                    eventType: eventType,
                                    isSelected: eventStore.selectedEventTypes.contains(eventType)
                                ) {
                                    toggleEventType(eventType)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Button {
                                eventStore.selectedEventTypes = Set(EventType.allCases)
                                eventStore.searchText = ""
                            } label: {
                                Text("Reset Filters")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(AppColors.accent)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.accent.opacity(0.1))
                                    .cornerRadius(25)
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle()) 
                            .buttonStyle(PlainButtonStyle())
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Apply Filters")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(AppColors.background)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.accent)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func toggleEventType(_ eventType: EventType) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        if eventStore.selectedEventTypes.contains(eventType) {
            eventStore.selectedEventTypes.remove(eventType)
        } else {
            eventStore.selectedEventTypes.insert(eventType)
        }
    }
}

struct FilterTypeRow: View {
    let eventType: EventType
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                Image(systemName: eventType.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.background : AppColors.accent)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? AppColors.accent : AppColors.accent.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(eventType.displayName)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(eventTypeDescription)
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppColors.accent : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var eventTypeDescription: String {
        switch eventType {
        case .birthday:
            return "Birthdays and personal celebrations"
        case .anniversary:
            return "Wedding anniversaries and milestones"
        case .holiday:
            return "Unusual and fun holidays"
        case .other:
            return "Other important events"
        }
    }
}

#Preview {
    FilterSheetView(eventStore: EventStore())
}
