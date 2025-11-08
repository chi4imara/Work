import SwiftUI

struct EntryDetailView: View {
    let entry: WonderEntry
    @ObservedObject var viewModel: WonderViewModel
    @State private var showingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(entry.title)
                            .font(.appTitle)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(entry.displayDateTime)
                            .font(.appCaption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        if !entry.description.isEmpty {
                            Text(entry.description)
                                .font(.appBody)
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.showEditEntry(entry)
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.appSubheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(.appSubheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.error)
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(entry)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
        .sheet(item: $viewModel.selectedEntry) { entry in
            AddEditEntryView(viewModel: viewModel, entry: entry)
        }
    }
}

#Preview {
    let sampleEntry = WonderEntry(
        title: "Found an old book in the attic",
        description: "Discovered a collection of journals from the 60s. They contain fascinating stories about life back then and some beautiful handwritten notes.",
        date: Date(),
        time: Date()
    )
    
    return NavigationView {
        EntryDetailView(entry: sampleEntry, viewModel: WonderViewModel())
    }
}
