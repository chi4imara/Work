import SwiftUI

struct AccessoryDetailView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    let accessoryId: UUID
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var accessory: Accessory? {
        viewModel.getAccessory(by: accessoryId)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let accessory = accessory {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(accessory.name)
                                            .font(.ubuntu(24, weight: .bold))
                                            .foregroundColor(AppColors.primaryWhite)
                                            .lineLimit(nil)
                                        
                                        Text(accessory.type.displayName)
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(accessory.status.displayName)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(AppColors.primaryWhite)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.statusColor(for: accessory.status))
                                        .cornerRadius(16)
                                }
                                
                                Text("Added \(accessory.dateCreated, formatter: dateFormatter)")
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                            }
                            .padding(20)
                            .background(AppColors.cardBackground)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            
                            if !accessory.description.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Description")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(AppColors.primaryWhite)
                                    
                                    Text(accessory.description)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(AppColors.cardBackground)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                            
                            if !accessory.comment.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Comment")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(AppColors.primaryWhite)
                                    
                                    Text(accessory.comment)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(AppColors.cardBackground)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Edit")
                                            .font(.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primaryWhite)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Delete")
                                            .font(.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.statusLost)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("Accessory not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Button("Go Back") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryWhite)
                        .cornerRadius(20)
                    }
                }
            }
            .navigationTitle("Accessory Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingEditView) {
                if let accessory = accessory {
                    EditAccessoryView(viewModel: viewModel, accessoryId: accessory.id)
                }
            }
            .alert("Delete Accessory", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let accessory = accessory {
                        viewModel.deleteAccessory(accessory)
                    }
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this accessory? This action cannot be undone.")
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    let viewModel = AccessoryViewModel()
    let accessory = Accessory(
        name: "Ray-Ban Sunglasses",
        type: .glasses,
        status: .favorite,
        description: "Classic black frame sunglasses with UV protection",
        comment: "Perfect for summer days, very comfortable"
    )
    viewModel.addAccessory(accessory)
    
    return NavigationView {
        AccessoryDetailView(
            viewModel: viewModel,
            accessoryId: accessory.id
        )
    }
}
