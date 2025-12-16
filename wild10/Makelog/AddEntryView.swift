import SwiftUI

struct AddEntryView: View {
    @ObservedObject var weatherEntriesViewModel: WeatherEntriesViewModel
    @StateObject private var createEntryViewModel: CreateEntryViewModel
    @Binding var selectedTab: Int
    
    init(weatherEntriesViewModel: WeatherEntriesViewModel, selectedTab: Binding<Int>) {
        self.weatherEntriesViewModel = weatherEntriesViewModel
        self._selectedTab = selectedTab
        _createEntryViewModel = StateObject(wrappedValue: CreateEntryViewModel(
            weatherEntriesViewModel: weatherEntriesViewModel
        ))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Weather Description")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextEditor(text: $createEntryViewModel.description)
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
                                            if createEntryViewModel.description.isEmpty {
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
                                ForEach(weatherEntriesViewModel.categories, id: \.id) { category in
                                    Button(category.name) {
                                        createEntryViewModel.selectedCategory = category
                                    }
                                }
                                
                                Divider()
                                
                                Button("Create New Category") {
                                    createEntryViewModel.isShowingNewCategoryAlert = true
                                }
                            } label: {
                                HStack {
                                    Text(createEntryViewModel.selectedCategory.name)
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
                                selection: $createEntryViewModel.selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(AppColors.primaryPurple)
                            .colorInvert()
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
                        
                        Button(action: {
                            saveEntry()
                        }) {
                            HStack {
                                Spacer()
                                Text("Save Entry")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.buttonText)
                                Spacer()
                            }
                            .padding(.vertical, AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                    .fill(createEntryViewModel.canSave ? AppColors.buttonBackground : AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                            .stroke(createEntryViewModel.canSave ? Color.clear : AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                        .disabled(!createEntryViewModel.canSave)
                        .padding(.top, AppSpacing.md)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(AppSpacing.md)
                }
            }
        }
        .alert("New Category", isPresented: $createEntryViewModel.isShowingNewCategoryAlert) {
            TextField("Category name", text: $createEntryViewModel.newCategoryName)
            Button("Create") {
                createEntryViewModel.createNewCategory()
            }
            Button("Cancel", role: .cancel) {
                createEntryViewModel.newCategoryName = ""
            }
        } message: {
            Text("Enter a name for the new weather category.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("New Entry")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }
    
    private func saveEntry() {
        guard createEntryViewModel.canSave else { return }
        
        HapticFeedback.success()
        createEntryViewModel.save()
        
        createEntryViewModel.description = ""
        createEntryViewModel.selectedDate = Date()
        createEntryViewModel.selectedCategory = WeatherCategory.sunny
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedTab = 0
        }
    }
}

#Preview {
    NavigationView {
        AddEntryView(
            weatherEntriesViewModel: WeatherEntriesViewModel(),
            selectedTab: .constant(3)
        )
    }
}
