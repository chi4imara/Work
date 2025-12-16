import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    let entry: BeautyEntry
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentEntry: BeautyEntry {
        viewModel.getEntry(by: entry.id) ?? entry
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        DetailSectionView(title: "Date", content: currentEntry.formattedDate)
                        
                        DetailSectionView(title: "Procedure", content: currentEntry.procedureName)
                        
                        DetailSectionView(title: "Products Used", content: currentEntry.products.isEmpty ? "No products listed" : currentEntry.products)
                        
                        DetailSectionView(
                            title: "Notes",
                            content: currentEntry.hasNotes ? currentEntry.notes : "No notes."
                        )
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.toggleFavorite(for: currentEntry)
                        }) {
                            Image(systemName: currentEntry.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(currentEntry.isFavorite ? Color.theme.accentPink : Color.theme.secondaryText)
                        }
                        
                        Button(action: {
                            showingEditView = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.primaryBlue)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.accentPink)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditEntryView(viewModel: viewModel, entry: currentEntry)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(currentEntry)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(content)
                .font(.playfairDisplay(16))
                .foregroundColor(content.contains("No ") ? Color.theme.secondaryText : Color.theme.primaryText)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.theme.cardBackground)
                .cornerRadius(12)
        }
    }
}

#Preview {
    EntryDetailView(
        viewModel: BeautyDiaryViewModel(),
        entry: BeautyEntry.sampleEntries[0]
    )
}
