import SwiftUI

struct MonthDetailsView: View {
    @ObservedObject var memoryStore: MemoryStore
    let monthDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    private var monthMemories: [Memory] {
        memoryStore.memoriesForMonth(monthDate).sorted { $0.date > $1.date }
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: monthDate)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Text(monthTitle)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    HStack {
                        Text("Back")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.clear)
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                if monthMemories.isEmpty {
                    emptyStateView
                } else {
                    memoriesList
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "calendar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            Text("No memories for this month")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Start adding memories to see them here")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var memoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(monthMemories) { memory in
                    MonthMemoryCardView(memory: memory, memoryStore: memoryStore)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct MonthMemoryCardView: View {
    let memory: Memory
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(DateFormatter.dayNumber.string(from: memory.date))
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text(DateFormatter.shortMonth.string(from: memory.date))
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(width: 50)
                
                Text(memory.mood)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(memory.title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(memory.description)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if memory.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColors.primaryYellow)
                        .font(.system(size: 16))
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            MemoryDetailView(memoryID: memory.id, memoryStore: memoryStore)
        }
    }
}

extension DateFormatter {
    static let dayNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    static let shortMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
}

#Preview {
    MonthDetailsView(memoryStore: MemoryStore(), monthDate: Date())
}
