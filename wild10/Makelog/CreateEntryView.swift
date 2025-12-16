import SwiftUI

struct CreateEntryView: View {
    @ObservedObject var viewModel: CreateEntryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Weather Description")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextEditor(text: $viewModel.description)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(AppSpacing.md)
                                .frame(minHeight: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                                .scrollContentBackground(.hidden)
                                .overlay(
                                    VStack {
                                        HStack {
                                            if viewModel.description.isEmpty {
                                                Text("Describe today's weather in your own words...")
                                                    .font(AppFonts.body)
                                                    .foregroundColor(AppColors.textTertiary)
                                                    .padding(.top, AppSpacing.md)
                                                    .padding(.leading, AppSpacing.md + 4)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Category")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Menu {
                                ForEach(viewModel.weatherEntriesViewModel.categories, id: \.id) { category in
                                    Button(category.name) {
                                        viewModel.selectedCategory = category
                                    }
                                }
                                
                                Divider()
                                
                                Button("Create New Category") {
                                    viewModel.isShowingNewCategoryAlert = true
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedCategory.name)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Date")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            DatePicker(
                                "",
                                selection: $viewModel.selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .colorInvert()
                            .accentColor(AppColors.primaryPurple)
                            .padding(AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                        
                        Spacer(minLength: 100) 
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(viewModel.canSave ? AppColors.primaryPurple : AppColors.textTertiary)
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .alert("New Category", isPresented: $viewModel.isShowingNewCategoryAlert) {
            TextField("Category name", text: $viewModel.newCategoryName)
            Button("Create") {
                viewModel.createNewCategory()
            }
            Button("Cancel", role: .cancel) {
                viewModel.newCategoryName = ""
            }
        } message: {
            Text("Enter a name for the new weather category.")
        }
    }
}

#Preview {
    CreateEntryView(
        viewModel: CreateEntryViewModel(
            weatherEntriesViewModel: WeatherEntriesViewModel()
        )
    )
}
