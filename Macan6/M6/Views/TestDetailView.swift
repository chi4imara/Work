import SwiftUI

struct TestDetailView: View {
    let testId: UUID
    @ObservedObject var viewModel: TestsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingStatusPicker = false
    @State private var selectedStatus: TestStatus
    
    private var test: TestModel? {
        viewModel.tests.first { $0.id == testId }
    }
    
    init(testId: UUID, viewModel: TestsViewModel) {
        self.testId = testId
        self.viewModel = viewModel
        self._selectedStatus = State(initialValue: .testing)
    }
    
    var body: some View {
        Group {
            if let currentTest = test {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerCard(test: currentTest)
                                
                                detailsCard(test: currentTest)
                                
                                effectCard(test: currentTest)
                                
                                actionButtons(test: currentTest)
                                
                                Spacer(minLength: 50)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle("Test Details")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                .sheet(isPresented: $showingEditView) {
                    Group {
                        if let testToEdit = viewModel.tests.first(where: { $0.id == testId }) {
                            EditTestView(test: testToEdit, viewModel: viewModel)
                        }
                    }
                }
                .actionSheet(isPresented: $showingStatusPicker) {
                    statusActionSheet(test: currentTest)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    deleteAlert(test: currentTest)
                }
                .preferredColorScheme(.dark)
                .id(testId)
                .onAppear {
                    selectedStatus = currentTest.status
                }
                .onChange(of: test?.status) { newStatus in
                    if let newStatus = newStatus {
                        selectedStatus = newStatus
                    }
                }
            } else {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        
                        VStack {
                            Text("Test not found")
                                .font(.playfairDisplay(18, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .navigationTitle("Test Details")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
        }
    }
    
    private func headerCard(test: TestModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(test.productName)
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(test.brand)
                        .font(.playfairDisplay(18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Image(systemName: test.status.icon)
                        .font(.system(size: 28))
                        .foregroundColor(statusColor(for: test.status))
                    
                    Text(test.status.displayName)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(statusColor(for: test.status))
                }
            }
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= test.rating ? "star.fill" : "star")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.yellow)
                }
                
                Text("(\(test.rating)/5)")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private func detailsCard(test: TestModel) -> some View {
        VStack(spacing: 16) {
            DetailRow(title: "Category", value: test.category.displayName)
            DetailRow(title: "Skin/Hair Type", value: test.skinType.displayName)
            DetailRow(title: "Test Date", value: DateFormatter.longDate.string(from: test.testDate))
        }
        .padding(20)
        .cardStyle()
    }
    
    private func effectCard(test: TestModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Effect & Results")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Text(test.effect.isEmpty ? "No effect description provided." : test.effect)
                .font(.playfairDisplay(16))
                .foregroundColor(test.effect.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                .lineSpacing(4)
            
            if !test.comment.isEmpty {
                Divider()
                    .background(AppColors.gridColor)
                
                Text("Comments")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(test.comment)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle()
    }
    
    private func actionButtons(test: TestModel) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Test")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.accentText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.yellow)
                .cornerRadius(12)
            }
            
            Button(action: { 
                selectedStatus = test.status
                showingStatusPicker = true 
            }) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Change Status")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Test")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.error.opacity(0.2))
                .cornerRadius(12)
            }
        }
    }
    
    private func statusActionSheet(test: TestModel) -> ActionSheet {
        ActionSheet(
            title: Text("Change Status"),
            buttons: TestStatus.allCases.map { status in
                .default(Text(status.displayName)) {
                    var updatedTest = test
                    updatedTest.status = status
                    viewModel.updateTest(updatedTest)
                    selectedStatus = status
                }
            } + [.cancel()]
        )
    }
    
    private func deleteAlert(test: TestModel) -> Alert {
        Alert(
            title: Text("Delete Test"),
            message: Text("Are you sure you want to delete this test? This action cannot be undone."),
            primaryButton: .destructive(Text("Delete")) {
                viewModel.deleteTest(test)
                presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel()
        )
    }
    
    private func statusColor(for status: TestStatus) -> Color {
        switch status {
        case .recommend:
            return AppColors.success
        case .notSuitable:
            return AppColors.error
        case .testing:
            return AppColors.warning
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    let test = TestModel(
        productName: "Hydra Cream",
        brand: "Laneige",
        category: .skincare,
        skinType: .dry,
        effect: "Excellent moisturizing, absorbs quickly.",
        rating: 5,
        status: .recommend,
        comment: "Perfect for winter."
    )
    let viewModel = TestsViewModel()
    viewModel.addTest(test)
    return TestDetailView(testId: test.id, viewModel: viewModel)
}
