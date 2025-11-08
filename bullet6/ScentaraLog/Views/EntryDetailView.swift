import SwiftUI

struct EntryDetailView: View {
    let entryId: UUID
    @ObservedObject var viewModel: ScentDiaryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingMenu = false
    
    var entry: ScentEntry? {
        if let entry = viewModel.filteredEntries.first(where: { $0.id == entryId }) {
             entry
        } else
            {
            nil
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                if let entry = entry {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(entry.name)
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        if !entry.category.isEmpty {
                            Text("Category: \(entry.category)")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.secondaryText)
                        } else {
                            Text("No category")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.lightText)
                                .italic()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Associations")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            if !entry.associations.isEmpty {
                                Text(entry.associations)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineSpacing(4)
                            } else {
                                Text("No associations added")
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.lightText)
                                    .italic()
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient.cardGradient)
                                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
                        )
                        
                        HStack {
                            Spacer()
                            
                            Text("Added \(entry.dateAdded, formatter: dateFormatter)")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.lightText)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Back")
                    }
                    .foregroundColor(AppColors.primaryPurple)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                    
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                        .rotationEffect(.degrees(90))
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditEntryView(viewModel: viewModel, entry: entry)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entryD = entry {
                    viewModel.deleteEntry(entryD)
                    presentationMode.wrappedValue.dismiss()
                    dismiss()
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}


