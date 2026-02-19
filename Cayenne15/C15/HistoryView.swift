import SwiftUI

struct HistoryView: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    @State private var selectedRecord: CarRecord?
    @State private var showingRecordDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("History")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(ColorManager.primaryText)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            if recordsViewModel.records.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "clock")
                        .font(.system(size: 60))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("You haven't added any records yet.")
                        .font(FontManager.playfairRegular(size: 18))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(recordsViewModel.records) { record in
                            HistoryRecordCard(record: record) {
                                selectedRecord = record
                                showingRecordDetails = true
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: $selectedRecord) { record in
            RecordDetailsView(
                recordId: record.id,
                recordsViewModel: recordsViewModel
            ) {
                showingRecordDetails = false
                selectedRecord = nil
            }
        }
    }
}

struct HistoryRecordCard: View {
    let record: CarRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(ColorManager.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: record.type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(ColorManager.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.type.rawValue)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text(record.formattedDate)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("Mileage: \(record.mileage)")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Open")
                        .font(FontManager.playfairMedium(size: 14))
                        .foregroundColor(ColorManager.orange)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(ColorManager.orange)
                }
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
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HistoryView(recordsViewModel: {
        let vm = CarRecordsViewModel()
        vm.addRecord(CarRecord(type: .wash, date: Date(), mileage: "124530", comment: "Full wash"))
        vm.addRecord(CarRecord(type: .fuel, date: Date().addingTimeInterval(-86400), mileage: "124500", comment: "Filled 50 liters"))
        return vm
    }())
}
