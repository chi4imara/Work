import SwiftUI

struct StatisticsView: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    @State private var selectedType: RecordType?
    @State private var showingTypeRecords = false
    
    var statistics: [RecordType: Int] {
        recordsViewModel.getStatistics()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Statistics")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(ColorManager.primaryText)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            if recordsViewModel.records.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "chart.bar")
                        .font(.system(size: 60))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("No data for statistics.")
                        .font(FontManager.playfairRegular(size: 18))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(RecordType.allCases, id: \.self) { type in
                            let count = statistics[type] ?? 0
                            StatisticsCategoryCard(
                                type: type,
                                count: count
                            ) {
                                selectedType = type
                                showingTypeRecords = true
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: $selectedType) { type in
            TypeRecordsView(
                type: type,
                records: recordsViewModel.getRecords(for: type),
                recordsViewModel: recordsViewModel
            ) {
                showingTypeRecords = false
                selectedType = nil
            }
        }
    }
}

struct StatisticsCategoryCard: View {
    let type: RecordType
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(ColorManager.lightBlue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.rawValue)
                        .font(FontManager.playfairSemiBold(size: 17))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("\(count) records")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(ColorManager.orange.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Text("\(count)")
                            .font(FontManager.playfairSemiBold(size: 16))
                            .foregroundColor(ColorManager.orange)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Open")
                            .font(FontManager.playfairMedium(size: 12))
                            .foregroundColor(ColorManager.orange)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(ColorManager.orange)
                    }
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
        .disabled(count == 0)
        .opacity(count == 0 ? 0.5 : 1.0)
    }
}

struct TypeRecordsView: View {
    let type: RecordType
    let records: [CarRecord]
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    let onDismiss: () -> Void
    
    @State private var selectedRecord: CarRecord?
    @State private var showingRecordDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if records.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: type.icon)
                                .font(.system(size: 60))
                                .foregroundColor(ColorManager.secondaryText)
                            
                            Text("No \(type.rawValue.lowercased()) records found.")
                                .font(FontManager.playfairRegular(size: 18))
                                .foregroundColor(ColorManager.secondaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(records) { record in
                                    TypeRecordCard(record: record) {
                                        selectedRecord = record
                                        showingRecordDetails = true
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationTitle("\(type.rawValue) Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundColor(ColorManager.orange)
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

struct TypeRecordCard: View {
    let record: CarRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.formattedDate)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("Mileage: \(record.mileage)")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Open Record")
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
    StatisticsView(recordsViewModel: {
        let vm = CarRecordsViewModel()
        vm.addRecord(CarRecord(type: .wash, date: Date(), mileage: "124530", comment: "Full wash"))
        vm.addRecord(CarRecord(type: .fuel, date: Date().addingTimeInterval(-86400), mileage: "124500", comment: "Filled 50 liters"))
        vm.addRecord(CarRecord(type: .wash, date: Date().addingTimeInterval(-172800), mileage: "124450", comment: "Quick wash"))
        return vm
    }())
}
