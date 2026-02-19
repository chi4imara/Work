import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var selectedDate = Date()
    
    private var calendar: Calendar { Calendar.current }
    
    private var itemsForSelectedDate: [Item] {
        inventoryViewModel.items.filter { item in
            calendar.isDate(item.dateCreated, inSameDayAs: selectedDate)
        }
    }
    
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Calendar")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack {
                        VStack(spacing: 12) {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .colorInvert()
                                .tint(AppColors.primaryTextWhite)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.vertical, 10)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(formattedSelectedDate)
                                    .font(.playfairDisplay(18, weight: .semibold))
                                    .foregroundColor(AppColors.primaryTextWhite)
                                Spacer()
                                Text("\(itemsForSelectedDate.count) item(s)")
                                    .font(.playfairDisplay(14, weight: .medium))
                                    .foregroundColor(AppColors.secondaryTextWhite)
                            }
                            .padding(.horizontal, 4)
                            
                            if itemsForSelectedDate.isEmpty {
                                VStack(spacing: 16) {
                                    Spacer()
                                    
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 44))
                                        .foregroundColor(AppColors.primaryTextWhite.opacity(0.7))
                                    Text("No items added on this date")
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(AppColors.secondaryTextWhite)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(itemsForSelectedDate) { item in
                                        NavigationLink(destination: ItemDetailView(itemId: item.id).environmentObject(inventoryViewModel)) {
                                            ItemCardView(item: item)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 4)
                                .padding(.bottom, 120)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(InventoryViewModel())
}
