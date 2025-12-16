import SwiftUI

struct TodayView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingAddMemory = false
    @State private var showingMenu = false
    @Binding var selectedTab: Int
    
    private var todayMemory: Memory? {
        memoryStore.memoryForDate(Date())
    }
    
    private var recentMemories: [Memory] {
        memoryStore.memoriesForLastDays(7).filter { !Calendar.current.isDateInToday($0.date) }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Today")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingMenu = true }) {
                        Image(systemName: "ellipsis")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        todaySection
                        
                        if !recentMemories.isEmpty {
                            recentMemoriesSection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView(memoryStore: memoryStore)
        }
        .confirmationDialog("Menu", isPresented: $showingMenu) {
            Button("Summary") {
                withAnimation {
                    selectedTab = 3
                }
            }
            Button("Calendar") {
                withAnimation {
                    selectedTab = 2
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var todaySection: some View {
        VStack(spacing: 16) {
            Text(DateFormatter.fullDate.string(from: Date()))
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            if let memory = todayMemory {
                MemoryCardView(memory: memory, memoryStore: memoryStore)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "book")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                    
                    Text("No memory for today")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Button(action: { showingAddMemory = true }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Memory")
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(20)
                    }
                }
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var recentMemoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Last 7 Days")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recentMemories) { memory in
                        CompactMemoryCardView(memory: memory, memoryStore: memoryStore)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct MemoryCardView: View {
    let memory: Memory
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(memory.mood)
                        .font(.system(size: 32))
                    
                    Spacer()
                    
                    if memory.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
                
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

struct CompactMemoryCardView: View {
    let memory: Memory
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            VStack(spacing: 8) {
                Text(memory.mood)
                    .font(.system(size: 24))
                
                Text(DateFormatter.shortDate.string(from: memory.date))
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(memory.title)
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .frame(width: 120, height: 100)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            MemoryDetailView(memoryID: memory.id, memoryStore: memoryStore)
        }
    }
}

extension DateFormatter {
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}
