import SwiftUI

struct ManicureDetailView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @Environment(\.dismiss) private var dismiss
    
    let manicureId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        Group {
            if let manicure = manicureStore.getManicure(by: manicureId) {
                contentView(manicure: manicure)
            } else {
                Text("Manicure not found")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func contentView(manicure: Manicure) -> some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(AppColors.purpleGradient)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(manicure.color.prefix(2)).uppercased())
                                    .font(.playfairDisplay(24, weight: .bold))
                                    .foregroundColor(AppColors.contrastText)
                            )
                        
                        Text(manicure.color)
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        DetailCard(
                            icon: "calendar",
                            title: "Date",
                            content: dateFormatter.string(from: manicure.date)
                        )
                        
                        if !manicure.salon.isEmpty {
                            DetailCard(
                                icon: "location.fill",
                                title: "Salon / Master",
                                content: manicure.salon
                            )
                        }
                        
                        if !manicure.note.isEmpty {
                            DetailCard(
                                icon: "note.text",
                                title: "Notes",
                                content: manicure.note
                            )
                        } else {
                            DetailCard(
                                icon: "note.text",
                                title: "Notes",
                                content: "No notes"
                            )
                        }
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Text("Delete Record")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.backgroundWhite.opacity(0.9))
                            .cornerRadius(25)
                    }
                    .padding(.vertical, 10)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Manicure Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditView = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(AppColors.yellowAccent)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditManicureView(manicureId: manicureId)
        }
        .alert("Delete Record", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                manicureStore.deleteManicure(by: manicureId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this manicure record? This action cannot be undone.")
        }
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.yellowAccent)
                
                Text(title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(.playfairDisplay(16))
                .foregroundColor(AppColors.blueText)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
