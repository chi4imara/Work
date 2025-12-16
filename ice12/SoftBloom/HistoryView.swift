import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var searchText = ""
    @State private var selectedEntry: GratitudeEntry?
    
    private var filteredEntries: [GratitudeEntry] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return viewModel.entries
        }
        return viewModel.entries.filter { entry in
            entry.text.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("History & Search")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(.primaryPurple)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.accentBlue)
                            
                            TextField("Find by words...", text: $searchText)
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.darkGray)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.lightGray)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    if viewModel.entries.isEmpty {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            Image(systemName: "book.closed")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(.accentBlue.opacity(0.6))
                            
                            VStack(spacing: 12) {
                                Text("No Entries Yet")
                                    .font(.playfairDisplay(size: 24, weight: .bold))
                                    .foregroundColor(.primaryPurple)
                                
                                Text("Start writing your gratitude entries to see them here. Your journey of gratitude begins with a single entry.")
                                    .font(.playfairDisplay(size: 16))
                                    .foregroundColor(.darkGray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 20)
                            }
                            
                            Spacer()
                        }
                    } else if filteredEntries.isEmpty {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(.accentBlue.opacity(0.6))
                            
                            VStack(spacing: 12) {
                                Text("Nothing Found")
                                    .font(.playfairDisplay(size: 24, weight: .bold))
                                    .foregroundColor(.primaryPurple)
                                
                                Text("No entries match your search. Try different keywords or check your spelling.")
                                    .font(.playfairDisplay(size: 16))
                                    .foregroundColor(.darkGray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 20)
                            }
                            
                            Button(action: { searchText = "" }) {
                                Text("Reset")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.accentBlue)
                                    .cornerRadius(10)
                                    .shadow(color: Color.accentBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredEntries) { entry in
                                    HistoryEntryCard(entry: entry) {
                                        selectedEntry = entry
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedEntry) { entry in
                GratitudeDetailView(viewModel: viewModel, date: entry.date)
            }
        }
    }
}

struct HistoryEntryCard: View {
    let entry: GratitudeEntry
    let action: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(dateFormatter.string(from: entry.date))
                        .font(.playfairDisplay(size: 16, weight: .bold))
                        .foregroundColor(.primaryPurple)
                    
                    Text(entry.dayOfWeek)
                        .font(.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(.accentBlue)
                }
                .frame(width: 80)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.shortText)
                        .font(.playfairDisplay(size: 15))
                        .foregroundColor(.darkGray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if entry.text.count > 60 {
                        Text("Tap to read more...")
                            .font(.playfairDisplay(size: 12))
                            .foregroundColor(.accentBlue.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.lightGray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GratitudeViewModel()
        viewModel.addEntry(text: "Grateful for the beautiful sunrise this morning and the peaceful moment it brought me.", for: Date())
        viewModel.addEntry(text: "Thankful for my family's support.", for: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        
        return HistoryView(viewModel: viewModel)
    }
}
