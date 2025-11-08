import SwiftUI

struct AddEditSeriesView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let editingSeries: Series?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: SeriesCategory = .drama
    @State private var selectedCustomCategory: CustomCategory?
    @State private var selectedStatus: SeriesStatus = .watching
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isEditing: Bool {
        editingSeries != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.primaryBlue)
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Series" : "New Series")
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text("Back")
                        .font(.bodyLarge)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Series Title")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter series title", text: $title)
                                .font(.bodyLarge)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightBlue, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter description (optional)", text: $description, axis: .vertical)
                                .font(.bodyLarge)
                                .lineLimit(3...6)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightBlue, lineWidth: 1)
                                )
                            
                            Text("\(description.count)/200")
                                .font(.captionSmall)
                                .foregroundColor(.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            Menu {
                                ForEach(SeriesCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                        selectedCustomCategory = nil
                                    }
                                }
                                
                                if !viewModel.customCategories.isEmpty {
                                    Divider()
                                    ForEach(viewModel.customCategories, id: \.id) { customCategory in
                                        Button(customCategory.name) {
                                            selectedCategory = .custom
                                            selectedCustomCategory = customCategory
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    if selectedCategory == .custom, let customCategory = selectedCustomCategory {
                                        Text(customCategory.name)
                                            .font(.bodyLarge)
                                            .foregroundColor(.textPrimary)
                                    } else {
                                        Text(selectedCategory.displayName)
                                            .font(.bodyLarge)
                                            .foregroundColor(.textPrimary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightBlue, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            Menu {
                                ForEach(SeriesStatus.allCases, id: \.self) { status in
                                    Button(status.displayName) {
                                        selectedStatus = status
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedStatus.displayName)
                                        .font(.bodyLarge)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightBlue, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .padding(.bottom, 100)
                }
            }
            VStack {
                Spacer()
                Button(action: saveSeries) {
                    Text("Save")
                        .font(.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            canSave ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.statusWaiting, Color.statusWaiting]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                        )
                        .cornerRadius(16)
                        .shadow(color: canSave ? Color.primaryBlue.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                }
                .disabled(!canSave)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            if let series = editingSeries {
                title = series.title
                description = series.description
                selectedCategory = series.category
                selectedStatus = series.status
                if let customCategoryId = series.customCategoryId {
                    selectedCustomCategory = viewModel.getCustomCategory(by: customCategoryId)
                }
            }
        }
        .onChange(of: description) { newValue in
            if newValue.count > 200 {
                description = String(newValue.prefix(200))
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveSeries() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Please enter series title"
            showingError = true
            return
        }
        
        if let editingSeries = editingSeries {
            var updatedSeries = editingSeries
            updatedSeries.title = trimmedTitle
            updatedSeries.description = description
            updatedSeries.category = selectedCategory
            updatedSeries.customCategoryId = selectedCustomCategory?.id
            updatedSeries.status = selectedStatus
            
            viewModel.updateSeries(updatedSeries)
        } else {
            let newSeries = Series(
                title: trimmedTitle,
                description: description,
                category: selectedCategory,
                customCategoryId: selectedCustomCategory?.id,
                status: selectedStatus
            )
            
            viewModel.addSeries(newSeries)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
