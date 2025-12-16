import SwiftUI

struct CreateChallengeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var challengeText = ""
    @State private var selectedCategory: Category?
    @State private var showingCategoryPicker = false
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var showingSuccessAlert = false
    
    private let maxCharacters = 200
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("New Challenge")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Challenge Text")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Text("\(challengeText.count)/\(maxCharacters)")
                                    .font(.ubuntu(14))
                                    .foregroundColor(challengeText.count >= maxCharacters ? AppColors.warning : AppColors.textSecondary)
                            }
                            
                            TextEditor(text: Binding(
                                get: { challengeText },
                                set: { newValue in
                                    if newValue.count <= maxCharacters {
                                        challengeText = newValue
                                    } else {
                                        challengeText = String(newValue.prefix(maxCharacters))
                                    }
                                }
                            ))
                            .font(.ubuntu(16))
                            .padding(12)
                            .frame(minHeight: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(challengeText.count >= maxCharacters ? AppColors.warning.opacity(0.5) : AppColors.primary.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Button(action: { showingCategoryPicker = true }) {
                                HStack {
                                    Text(selectedCategory?.name ?? "Select Category")
                                        .font(.ubuntu(16))
                                        .foregroundColor(selectedCategory != nil ? AppColors.textPrimary : AppColors.textSecondary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        
                        Button(action: saveChallenge) {
                            Text("Save Challenge")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: canSave ? [AppColors.primary, AppColors.secondary] : [AppColors.textSecondary, AppColors.textSecondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: canSave ? AppColors.primary.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            if selectedCategory == nil && !dataManager.categories.isEmpty {
                selectedCategory = dataManager.categories.first
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategorySelectionView(
                selectedCategory: $selectedCategory,
                showingAddCategory: $showingAddCategory
            )
            .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(categoryName: $newCategoryName) {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let category = Category(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
                    dataManager.addCategory(category)
                    selectedCategory = category
                    newCategoryName = ""
                    showingAddCategory = false
                }
            }
        }
        .alert("Challenge Saved!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                clearForm()
            }
        } message: {
            Text("Your challenge has been added successfully!")
        }
    }
    
    private var canSave: Bool {
        let trimmedText = challengeText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty && 
               trimmedText.count <= maxCharacters && 
               selectedCategory != nil
    }
    
    private func saveChallenge() {
        guard let category = selectedCategory else { return }
        
        let challenge = Challenge(
            text: challengeText.trimmingCharacters(in: .whitespacesAndNewlines),
            categoryId: category.id
        )
        
        dataManager.addChallenge(challenge)
        showingSuccessAlert = true
    }
    
    private func clearForm() {
        challengeText = ""
        selectedCategory = dataManager.categories.first
    }
}

struct CategorySelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategory: Category?
    @Binding var showingAddCategory: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(dataManager.categories) { category in
                        Button(action: {
                            selectedCategory = category
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(category.name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                if selectedCategory?.id == category.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        showingAddCategory = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(AppColors.primary)
                            Text("Create New Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    CreateChallengeView()
        .environmentObject(DataManager.shared)
}
