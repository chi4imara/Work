import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: NoticeViewModel
    @State private var searchText = ""
    @State private var selectedEntry: DayEntry?
    @State private var cardScale: CGFloat = 0.9
    @State private var animationOffset: CGFloat = 0
    
    private var filteredEntries: [DayEntry] {
        viewModel.searchEntries(query: searchText)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.accentGold.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .offset(x: -10, y: -5)
                            
                            Circle()
                                .fill(Color.theme.primaryPurple.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .offset(x: 15, y: 8)
                            
                            Image(systemName: "folder")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        
                        Text("Archive of Observations")
                            .font(.ubuntu(28, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.theme.placeholderText)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Search your observations...", text: $searchText)
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.theme.cardBorder, Color.theme.cardBorder.opacity(0.5)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: Color.theme.primaryPurple.opacity(0.1),
                                    radius: 10,
                                    x: 0,
                                    y: 5
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        HStack {
                            if !searchText.isEmpty {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color.theme.accentGold)
                                    
                                    Text("Found: \(filteredEntries.count) days")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                selectedEntry = viewModel.getTodayEntry()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("Today's Summary")
                                        .font(.ubuntu(12, weight: .medium))
                                }
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.theme.primaryPurple.opacity(0.3), Color.theme.accentGold.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if filteredEntries.isEmpty {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentGold.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: searchText.isEmpty ? "book.closed" : "magnifyingglass")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            
                            VStack(spacing: 12) {
                                Text(searchText.isEmpty ? "Archive is empty" : "No results found")
                                    .font(.ubuntu(20, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text(searchText.isEmpty ? 
                                     "Every morning, day and evening — a chance to notice life." :
                                     "No entries found for '\(searchText)'")
                                    .font(.ubuntu(16, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(filteredEntries.enumerated()), id: \.element) { index, entry in
                                ArchiveEntryCard(entry: entry, index: index) {
                                    selectedEntry = entry
                                }
                                .scaleEffect(cardScale)
                                .offset(y: animationOffset)
                                .animation(
                                    .easeOut(duration: 0.3)
                                    .delay(Double(index) * 0.1),
                                    value: cardScale
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                cardScale = 1.0
                animationOffset = 0
            }
        }
        .sheet(item: $selectedEntry) { entry in
            ArchiveDetailView(entry: entry)
        }
    }
}

struct ArchiveEntryCard: View {
    let entry: DayEntry
    let index: Int
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateFormatter.string(from: entry.date))
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("\(entry.completedPeriodsCount) of 3 periods")
                            .font(.ubuntu(12, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { period in
                            Circle()
                                .fill(period < entry.completedPeriodsCount ? Color.theme.accentGold : Color.theme.placeholderText.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    EntryRow(
                        icon: "sun.max",
                        title: "Morning",
                        text: entry.morningEntry,
                        isCompleted: entry.morningEntry != nil
                    )
                    
                    EntryRow(
                        icon: "sun.max.fill",
                        title: "Day",
                        text: entry.dayEntry,
                        isCompleted: entry.dayEntry != nil
                    )
                    
                    EntryRow(
                        icon: "moon",
                        title: "Evening",
                        text: entry.eveningEntry,
                        isCompleted: entry.eveningEntry != nil
                    )
                }
                
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Open")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryPurple)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.theme.primaryPurple)
                            .rotationEffect(.degrees(isPressed ? 90 : 0))
                            .animation(.easeInOut(duration: 0.15), value: isPressed)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.cardBackground, Color.theme.cardBackground.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.theme.cardBorder, Color.theme.cardBorder.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: Color.theme.primaryPurple.opacity(0.1),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EntryRow: View {
    let icon: String
    let title: String
    let text: String?
    let isCompleted: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.theme.accentGold.opacity(0.2) : Color.theme.cardBackground)
                    .frame(width: 28, height: 28)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isCompleted ? Color.theme.accentGold : Color.theme.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.theme.accentGold)
                    }
                    
                    Spacer()
                }
                
                Text(text ?? "—")
                    .font(.ubuntu(13, weight: .light))
                    .foregroundColor(text != nil ? Color.theme.secondaryText : Color.theme.placeholderText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ArchiveDetailView: View {
    let entry: DayEntry
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryPurple)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text(dateFormatter.string(from: entry.date))
                    .font(.ubuntu(24, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 24) {
                    DetailEntrySection(
                        icon: "sun.max",
                        title: "Morning",
                        text: entry.morningEntry
                    )
                    
                    DetailEntrySection(
                        icon: "sun.max.fill",
                        title: "Day",
                        text: entry.dayEntry
                    )
                    
                    DetailEntrySection(
                        icon: "moon",
                        title: "Evening",
                        text: entry.eveningEntry
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("Three glances, three moments — and the whole day comes alive.")
                    .font(.ubuntuItalic(16, weight: .light))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
        }
    }
}

struct DetailEntrySection: View {
    let icon: String
    let title: String
    let text: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.theme.accentGold)
                
                Text(title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
            }
            
            Text(text ?? "—")
                .font(.ubuntu(16, weight: .light))
                .foregroundColor(text != nil ? Color.theme.primaryText : Color.theme.placeholderText)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 32)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    ArchiveView(viewModel: NoticeViewModel())
}
