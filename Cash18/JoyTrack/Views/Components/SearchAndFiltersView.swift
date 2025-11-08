import SwiftUI

struct SearchAndFiltersView: View {
    @ObservedObject var eventStore: EventStore
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
                
                TextField("Search events...", text: $eventStore.searchText)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
                
                if !eventStore.searchText.isEmpty {
                    Button(action: { eventStore.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
            
            if eventStore.selectedEventTypes.count < EventType.allCases.count {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(eventStore.selectedEventTypes), id: \.self) { eventType in
                            HStack(spacing: 4) {
                                Image(systemName: eventType.icon)
                                    .font(.system(size: 12))
                                Text(eventType.displayName)
                                    .font(FontManager.small)
                            }
                            .foregroundColor(AppColors.background)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.accent)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    SearchAndFiltersView(eventStore: EventStore())
}
