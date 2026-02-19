import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var viewModel: WishViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let entryId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Group {
            if let entry = viewModel.getEntry(by: entryId) {
                NavigationView {
                    ZStack {
                        AnimatedBackground()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 16) {
                                    Text("Entry")
                                        .font(.ubuntu(28, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                                            .frame(width: 16, height: 16)
                                        
                                        Text(entry.type.displayName)
                                            .font(.ubuntu(20, weight: .medium))
                                            .foregroundColor(entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill((entry.type == .want ? AppColors.wantColor : AppColors.dontWantColor).opacity(0.2))
                                    )
                                }
                                .padding(.top, 20)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Description")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Text(entry.text)
                                        .font(.ubuntu(18))
                                        .foregroundColor(AppColors.primaryText)
                                        .lineSpacing(6)
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                                
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Created")
                                            .font(.ubuntu(14, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Spacer()
                                        
                                        Text(formatDate(entry.createdAt))
                                            .font(.ubuntu(14))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    
                                    if entry.updatedAt != entry.createdAt {
                                        HStack {
                                            Text("Updated")
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(AppColors.secondaryText)
                                            
                                            Spacer()
                                            
                                            Text(formatDate(entry.updatedAt))
                                                .font(.ubuntu(14))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground.opacity(0.5))
                                )
                                
                                Spacer(minLength: 40)
                                
                                VStack(spacing: 16) {
                                    Button(action: { showingEditView = true }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "pencil")
                                                .font(.title3)
                                            
                                            Text("Edit")
                                                .font(.ubuntu(18, weight: .medium))
                                        }
                                        .foregroundColor(AppColors.buttonText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(AppColors.buttonBackground)
                                        .cornerRadius(12)
                                    }
                                    
                                    Button(action: { showingDeleteAlert = true }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "trash")
                                                .font(.title3)
                                            
                                            Text("Delete")
                                                .font(.ubuntu(18, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(AppColors.dontWantColor)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.bottom, 30)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                            .font(.ubuntu(16))
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditEntryView(viewModel: viewModel, entryId: entryId)
                }
                .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let entryToDelete = viewModel.getEntry(by: entryId) {
                            viewModel.deleteEntry(entryToDelete)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this entry? This action cannot be undone.")
                }
            } else {
                Text("Entry not found")
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
