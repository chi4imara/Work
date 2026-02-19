import SwiftUI

struct ReportsView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var selectedReportType: ReportType = .all
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var showingDatePicker = false
    @State private var showingShareSheet = false
    @State private var reportText = ""
    
    enum ReportType: String, CaseIterable {
        case all = "All"
        case dateRange = "Date Range"
        case byLocation = "By Location"
        case recent = "Recent"
    }
    
    var filteredPurchases: [Purchase] {
        switch selectedReportType {
        case .all:
            return viewModel.sortedPurchases
        case .dateRange:
            return viewModel.purchases.filter { purchase in
                purchase.date >= startDate && purchase.date <= endDate
            }.sorted { $0.date > $1.date }
        case .byLocation:
            return viewModel.purchases.filter { !$0.whereBought.isEmpty }
                .sorted { $0.date > $1.date }
        case .recent:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return viewModel.purchases.filter { $0.date >= weekAgo }
                .sorted { $0.date > $1.date }
        }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...18))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack {
                HStack {
                    Text("Reports")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.purchases.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        VStack(spacing: 8) {
                            Text("No Reports Available")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                            
                            Text("Add purchases to generate reports")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 16) {
                            Picker("Report Type", selection: $selectedReportType) {
                                ForEach(ReportType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            if selectedReportType == .dateRange {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("From")
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.white.opacity(0.8))
                                        
                                        Button(action: {
                                            showingDatePicker = true
                                        }) {
                                            HStack {
                                                Text(startDate, style: .date)
                                                    .font(.ubuntu(14, weight: .medium))
                                                    .foregroundColor(ColorTheme.white)
                                                
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(ColorTheme.white)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(ColorTheme.cardBackground.opacity(0.2))
                                            .cornerRadius(8)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("To")
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.white.opacity(0.8))
                                        
                                        Button(action: {
                                            showingDatePicker = true
                                        }) {
                                            HStack {
                                                Text(endDate, style: .date)
                                                    .font(.ubuntu(14, weight: .medium))
                                                    .foregroundColor(ColorTheme.white)
                                                
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(ColorTheme.white)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(ColorTheme.cardBackground.opacity(0.2))
                                            .cornerRadius(8)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            HStack {
                                Text("\(filteredPurchases.count) purchases")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    generateReport()
                                    showingShareSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 14, weight: .medium))
                                        Text("Export")
                                            .font(.ubuntu(14, weight: .medium))
                                    }
                                    .foregroundColor(ColorTheme.primaryBlue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(ColorTheme.white)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                        }
                        
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredPurchases) { purchase in
                                    ReportPurchaseRowView(purchase: purchase)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DateRangePickerView(startDate: $startDate, endDate: $endDate)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [reportText])
        }
    }
    
    private func generateReport() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var report = "Purchase Report\n"
        report += "================\n\n"
        report += "Report Type: \(selectedReportType.rawValue)\n"
        
        if selectedReportType == .dateRange {
            report += "Date Range: \(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))\n"
        }
        
        report += "Total Purchases: \(filteredPurchases.count)\n"
        report += "Generated: \(dateFormatter.string(from: Date()))\n\n"
        report += "Purchases:\n"
        report += "----------\n\n"
        
        for (index, purchase) in filteredPurchases.enumerated() {
            report += "\(index + 1). \(purchase.whatBought)\n"
            report += "   Date: \(dateFormatter.string(from: purchase.date))\n"
            if !purchase.whereBought.isEmpty {
                report += "   Where: \(purchase.whereBought)\n"
            }
            if !purchase.whyBought.isEmpty {
                report += "   Why: \(purchase.whyBought)\n"
            }
            report += "\n"
        }
        
        reportText = report
    }
}

struct ReportPurchaseRowView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(purchase.whatBought)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.darkGray)
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text(purchase.date, style: .date)
                                .font(.ubuntu(12, weight: .regular))
                        }
                        .foregroundColor(ColorTheme.darkGray.opacity(0.7))
                        
                        if !purchase.whereBought.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 10))
                                Text(purchase.whereBought)
                                    .font(.ubuntu(12, weight: .regular))
                                    .lineLimit(1)
                            }
                            .foregroundColor(ColorTheme.darkGray.opacity(0.7))
                        }
                    }
                    
                    if !purchase.whyBought.isEmpty {
                        Text(purchase.whyBought)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.darkGray.opacity(0.8))
                            .lineLimit(2)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct DateRangePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Date")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                        
                        DatePicker("", selection: $startDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(ColorTheme.yellow)
                            .colorScheme(.dark)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("End Date")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                        
                        DatePicker("", selection: $endDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(ColorTheme.yellow)
                            .colorScheme(.dark)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Select Date Range")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.yellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
