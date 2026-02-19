import SwiftUI

struct RecordDetailsView: View {
    let recordId: UUID
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    let onDismiss: () -> Void
    
    @State private var recordToEdit: CarRecord?
    @State private var showingDeleteAlert = false
    
    private var recordFull: CarRecord? {
        recordsViewModel.getRecord(by: recordId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                if let record = recordFull {
                    ScrollView {
                        VStack(spacing: 30) {
                            VStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(ColorManager.lightBlue.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                    
                                    Image(systemName: record.type.icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(ColorManager.lightBlue)
                                }
                                
                                Text(record.type.rawValue)
                                    .font(FontManager.playfairBold(size: 24))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 20) {
                                DetailInfoCard(
                                    icon: "calendar",
                                    title: "Date",
                                    value: record.formattedDate
                                )
                                
                                DetailInfoCard(
                                    icon: "speedometer",
                                    title: "Mileage",
                                    value: record.mileage
                                )
                                
                                DetailInfoCard(
                                    icon: "text.bubble",
                                    title: "Comment",
                                    value: record.displayComment
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 30)
                            
                            VStack(spacing: 15) {
                                Button(action: { recordToEdit = record }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16))
                                        
                                        Text("Edit")
                                            .font(FontManager.playfairSemiBold(size: 18))
                                    }
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(ColorManager.accentGradient)
                                    .cornerRadius(28)
                                }
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16))
                                        
                                        Text("Delete Record")
                                            .font(FontManager.playfairSemiBold(size: 18))
                                    }
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(ColorManager.red)
                                    .cornerRadius(28)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 50)
                        }
                    }
                } else {
                    VStack {
                        Text("Record not found")
                            .font(FontManager.playfairRegular(size: 18))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        onDismiss()
                    }
                    .foregroundColor(ColorManager.orange)
                }
            }
        }
        .sheet(item: $recordToEdit) { record in
            EditRecordView(
                record: record,
                recordsViewModel: recordsViewModel
            ) {
                recordToEdit = nil
            }
        }
        .alert("Delete Record", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let record = recordFull {
                    recordsViewModel.deleteRecord(record)
                }
                onDismiss()
            }
        } message: {
            Text("Are you sure you want to delete this record? This action cannot be undone.")
        }
    }
}

struct DetailInfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text(title)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Text(value)
                .font(FontManager.playfairRegular(size: 18))
                .foregroundColor(ColorManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.darkBlue.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

#Preview {
    let record = CarRecord(
        type: .wash,
        date: Date(),
        mileage: "124530",
        comment: "Full wash with interior cleaning"
    )
    let vm = CarRecordsViewModel()
    vm.addRecord(record)
    return RecordDetailsView(
        recordId: record.id,
        recordsViewModel: vm
    ) {}
}
