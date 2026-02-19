import SwiftUI

struct TodayView: View {
    @ObservedObject var appState: AppState
    @State private var showingAddRecipe = false
    @State private var showingEditIngredients = false
    @State private var selectedRecipeDestination: RecipeDetailDestination?
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Good Morning"
        } else if hour < 18 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting)
                                    .font(.appTitle)
                                    .foregroundColor(.appWhite)
                                
                                Text("What's for breakfast today?")
                                    .font(.appCallout)
                                    .foregroundColor(.appWhite.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddRecipe = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.appWhite)
                                    .frame(width: 44, height: 44)
                                    .background(Color.appOrange)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Breakfast Ideas")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(appState.todayRecommendations) { recipe in
                                        RecipeCard(
                                            recipe: recipe,
                                            onFavoriteToggle: {
                                                appState.toggleFavorite(for: recipe)
                                            },
                                            onCookedToggle: {
                                                if recipe.isCooked {
                                                    appState.unmarkAsCooked(recipe)
                                                } else {
                                                    appState.markAsCooked(recipe)
                                                }
                                            },
                                            onTap: {
                                                selectedRecipeDestination = RecipeDetailDestination(id: recipe.id)
                                            }
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Available Ingredients")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            Spacer()
                            
                            Button("Edit") {
                                showingEditIngredients = true
                            }
                            .font(.appCallout)
                            .foregroundColor(.appOrange)
                        }
                        .padding(.horizontal, 20)
                        
                        IngredientsList(appState: appState)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Weekly Plan")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        WeeklyPlanView(appState: appState)
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView(appState: appState)
        }
        .sheet(isPresented: $showingEditIngredients) {
            EditIngredientsView(appState: appState)
        }
        .sheet(item: $selectedRecipeDestination) { destination in
            RecipeDetailView(recipeId: destination.id, appState: appState)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let onFavoriteToggle: () -> Void
    let onCookedToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.appHeadline)
                        .foregroundColor(.appWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.appCaption)
                            .foregroundColor(.appOrange)
                        
                        Text("\(recipe.cookingTime) min")
                            .font(.appCaption)
                            .foregroundColor(.appWhite.opacity(0.8))
                        
                        Spacer()
                        
                        Text(recipe.category.displayName)
                            .font(.appCaption2)
                            .foregroundColor(.appOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.appOrange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                Text(recipe.ingredients.prefix(3).joined(separator: ", "))
                    .font(.appCaption)
                    .foregroundColor(.appWhite.opacity(0.7))
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Button(action: onFavoriteToggle) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.appCallout)
                            .foregroundColor(recipe.isFavorite ? .appRed : .appWhite.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Button(action: onCookedToggle) {
                        HStack(spacing: 4) {
                            Image(systemName: recipe.isCooked ? "checkmark.circle.fill" : "circle")
                                .font(.appCaption)
                            Text(recipe.isCooked ? "Cooked" : "I Cooked This!")
                                .font(.appCaption)
                        }
                        .foregroundColor(.appWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(recipe.isCooked ? Color.appGreen : Color.appWhite.opacity(0.2))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(recipe.isCooked ? Color.clear : Color.appGreen, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(16)
            .frame(width: 280)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appWhite.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IngredientsList: View {
    @ObservedObject var appState: AppState
    @State private var newIngredient = ""
    @State private var showingAddIngredient = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if appState.availableIngredients.isEmpty {
                VStack(spacing: 12) {
                    Text("No ingredients added yet")
                        .font(.appCallout)
                        .foregroundColor(.appWhite.opacity(0.6))
                    
                    Button("Add First Ingredient") {
                        showingAddIngredient = true
                    }
                    .font(.appCallout)
                    .foregroundColor(.appOrange)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(appState.availableIngredients, id: \.self) { ingredient in
                            IngredientChip(
                                ingredient: ingredient,
                                onRemove: {
                                    appState.removeIngredient(ingredient)
                                }
                            )
                        }
                        
                        Button(action: {
                            showingAddIngredient = true
                        }) {
                            Image(systemName: "plus")
                                .font(.appCallout)
                                .foregroundColor(.appOrange)
                                .frame(width: 32, height: 32)
                                .background(Color.appOrange.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .alert("Add Ingredient", isPresented: $showingAddIngredient) {
            TextField("Ingredient name", text: $newIngredient)
            Button("Add") {
                if !newIngredient.isEmpty {
                    appState.addIngredient(newIngredient)
                    newIngredient = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newIngredient = ""
            }
        }
    }
}

struct EditIngredientsView: View {
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var newIngredientName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack(spacing: 12) {
                        TextField("Add ingredient...", text: $newIngredientName)
                            .font(.appBody)
                            .padding(16)
                            .background(Color.appWhite.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.appWhite)
                        
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(newIngredientName.isEmpty ? .appWhite.opacity(0.3) : .appOrange)
                        }
                        .disabled(newIngredientName.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if appState.availableIngredients.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "refrigerator")
                                .font(.system(size: 50))
                                .foregroundColor(.appWhite.opacity(0.3))
                            
                            Text("No ingredients yet")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            
                            Text("Add products you have at home to see matching recipes")
                                .font(.appBody)
                                .foregroundColor(.appWhite.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        List {
                            ForEach(appState.availableIngredients, id: \.self) { ingredient in
                                HStack {
                                    Text(ingredient)
                                        .font(.appBody)
                                        .foregroundColor(.appWhite)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        appState.removeIngredient(ingredient)
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.appCallout)
                                            .foregroundColor(.appRed)
                                    }
                                }
                                .listRowBackground(Color.appWhite.opacity(0.05))
                                .listRowSeparatorTint(.appWhite.opacity(0.2))
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { index in
                                    let ingredient = appState.availableIngredients[index]
                                    appState.removeIngredient(ingredient)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Available Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.appOrange)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onSubmit(of: .text) {
            addIngredient()
        }
    }
    
    private func addIngredient() {
        let trimmed = newIngredientName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        appState.addIngredient(trimmed)
        newIngredientName = ""
    }
}

struct IngredientChip: View {
    let ingredient: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(ingredient)
                .font(.appCaption)
                .foregroundColor(.appWhite)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.appWhite.opacity(0.8))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.appOrange.opacity(0.8))
        .cornerRadius(16)
    }
}

struct WeeklyPlanView: View {
    @ObservedObject var appState: AppState
    @State private var dateToPlan: Date?
    
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(weekDays, id: \.self) { date in
                WeeklyPlanRow(
                    date: date,
                    recipe: appState.recipeForDate(date),
                    appState: appState
                ) {
                    dateToPlan = date
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(
            item: Binding(
                get: { dateToPlan.map { IdentifiableDate(date: $0) } },
                set: { dateToPlan = $0?.date }
            ),
            onDismiss: { dateToPlan = nil }
        ) { identifiableDate in
            SelectRecipeForDayView(
                date: identifiableDate.date,
                appState: appState
            ) {
                dateToPlan = nil
            }
        }
    }
}

private struct IdentifiableDate: Identifiable {
    let id = UUID()
    let date: Date
}

private struct SelectRecipeForDayView: View {
    let date: Date
    @ObservedObject var appState: AppState
    var onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    private var dateLabel: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if appState.recipeForDate(date) != nil {
                        Button(action: {
                            appState.clearRecipeForDate(date)
                            dismiss()
                            onDismiss()
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.appRed)
                                Text("Clear plan for this day")
                                    .font(.appCallout)
                                    .foregroundColor(.appWhite)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                    }
                    
                    if appState.recipes.isEmpty {
                        Text("No recipes yet. Add recipes first.")
                            .font(.appBody)
                            .foregroundColor(.appWhite.opacity(0.7))
                            .padding(.vertical, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(appState.recipes) { recipe in
                                    Button(action: {
                                        appState.setRecipeForDate(recipe, date: date)
                                        dismiss()
                                        onDismiss()
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(recipe.name)
                                                    .font(.appHeadline)
                                                    .foregroundColor(.appWhite)
                                                Text("\(recipe.cookingTime) min - \(recipe.category.displayName)")
                                                    .font(.appCaption)
                                                    .foregroundColor(.appWhite.opacity(0.7))
                                            }
                                            Spacer()
                                            if appState.recipeForDate(date)?.id == recipe.id {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.appGreen)
                                            }
                                        }
                                        .padding(16)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("Breakfast for \(dateLabel)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                        onDismiss()
                    }
                    .foregroundColor(.appOrange)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct WeeklyPlanRow: View {
    let date: Date
    let recipe: Recipe?
    @ObservedObject var appState: AppState
    var onTap: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dayFormatter.string(from: date))
                        .font(.appFootnote)
                        .foregroundColor(.appWhite)
                    
                    Text(dateFormatter.string(from: date))
                        .font(.appCaption)
                        .foregroundColor(.appWhite.opacity(0.6))
                }
                .frame(width: 100, alignment: .leading)
                
                if let recipe = recipe {
                    HStack {
                        Text(recipe.name)
                            .font(.appCallout)
                            .foregroundColor(.appWhite)
                        
                        Spacer()
                        
                        Text("\(recipe.cookingTime) min")
                            .font(.appCaption)
                            .foregroundColor(.appOrange)
                        
                        Image(systemName: "chevron.right")
                            .font(.appCaption)
                            .foregroundColor(.appWhite.opacity(0.4))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.cardGradient)
                    .cornerRadius(8)
                } else {
                    HStack {
                        Text("No breakfast planned")
                            .font(.appCallout)
                            .foregroundColor(.appWhite.opacity(0.5))
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle")
                            .font(.appCallout)
                            .foregroundColor(.appOrange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.appWhite.opacity(0.05))
                    .cornerRadius(8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TodayView(appState: AppState())
}
