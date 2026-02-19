import SwiftUI

enum HomeSheetItem: Identifiable {
    case addEntry
    
    var id: String {
        switch self {
        case .addEntry:
            return "addEntry"
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: WishViewModel
    @State private var sheetItem: HomeSheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Wishes & Refusals")
                            .font(.ubuntu(26, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        if viewModel.totalCount > 0 {
                            Text("\(viewModel.totalCount) entries")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if viewModel.entries.isEmpty {
                    EmptyStateView {
                        sheetItem = .addEntry
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.entries) { entry in
                                WishEntryCard(entry: entry) {
                                    NotificationCenter.default.post(name: .entrySelected, object: entry.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { sheetItem = .addEntry }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Add")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(25)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addEntry:
                AddEntryView(viewModel: viewModel)
            }
        }
    }
}

struct EmptyStateView: View {
    let onAddTap: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
                
                VStack(spacing: 12) {
                    Text("No entries yet")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Here will appear your wishes and refusals. Add your first entry to capture your choice.")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
            }
            
            Button(action: onAddTap) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    Text("Add First Entry")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(AppColors.buttonBackground)
                .cornerRadius(12)
                .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
}

struct WishEntryCard: View {
    let entry: WishEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Circle()
                        .fill(entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                        .frame(width: 12, height: 12)
                    
                    Rectangle()
                        .fill(entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                        .frame(width: 2)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.type.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill((entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor).opacity(0.2))
                            )
                        
                        Spacer()
                        
                        Text(formatDate(entry.createdAt))
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text(entry.text)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    
                    Spacer(minLength: 0)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
