import SwiftUI

struct EntriesListView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var showingDayDetails = false
    @State private var showingEditView = false
    @State private var selectedEntry: GratitudeEntry?
    @State private var entryToDelete: GratitudeEntry?
    @State private var showingDeleteAlert = false
    @State private var showingNewEntry = false
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .opacity(0.1)
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.entries.isEmpty {
                    emptyStateView
                } else {
                    entriesListView
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(viewModel: viewModel, selectedDate: Date())
        }
        .sheet(item: $selectedEntry ) { item in
                DayDetailsView(viewModel: viewModel, date: item.date)
        }
        .sheet(isPresented: $showingEditView) {
            if let entry = selectedEntry {
                NewEntryView(viewModel: viewModel, selectedDate: entry.date, existingEntry: entry)
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                entryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteEntry(for: entry.date)
                }
                entryToDelete = nil
            }
        } message: {
            if let entry = entryToDelete {
                Text("Delete entry for \(entry.dateString)? This action cannot be undone.")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Entries List")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 8)
        .padding(.bottom, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(ColorTheme.accentYellow)
            
            Text("Your gratitude entries will appear here")
                .font(FontManager.callout)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Button {
                showingNewEntry = true
            } label: {
                Text("Add Entry")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.buttonBackground)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.entries) { entry in
                    EntryRowView(entry: entry)
                        .onTapGesture {
                            selectedEntry = entry
                            showingDayDetails = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Delete") {
                                entryToDelete = entry
                                showingDeleteAlert = true
                            }
                            .tint(ColorTheme.warningRed)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button("Edit") {
                                selectedEntry = entry
                                showingEditView = true
                            }
                            .tint(ColorTheme.buttonBackground)
                        }
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 80)
        }
    }
}

struct EntryRowView: View {
    let entry: GratitudeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.dateString)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                GratitudePreviewRow(
                    number: "1",
                    text: entry.firstGratitude,
                    color: ColorTheme.accentOrange
                )
                
                GratitudePreviewRow(
                    number: "2",
                    text: entry.secondGratitude,
                    color: ColorTheme.accentYellow
                )
                
                GratitudePreviewRow(
                    number: "3",
                    text: entry.thirdGratitude,
                    color: ColorTheme.successGreen
                )
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
        )
    }
}

struct GratitudePreviewRow: View {
    let number: String
    let text: String
    let color: Color
    
    private var previewText: String {
        let maxLength = 45
        if text.count > maxLength {
            return String(text.prefix(maxLength)) + "..."
        }
        return text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: 16, height: 16)
                
                Text(number)
                    .font(FontManager.caption2)
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Text(previewText)
                .font(FontManager.caption)
                .foregroundColor(ColorTheme.secondaryText)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    EntriesListView(viewModel: GratitudeViewModel())
}
