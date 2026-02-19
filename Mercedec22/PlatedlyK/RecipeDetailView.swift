import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    let recipeProvider: (UUID) -> Recipe?
    let onUpdate: (Recipe) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var recipe: Recipe?
    @State private var showingVideo = false
    @State private var currentStep = 0
    @State private var showingTimer = false
    @State private var timerSeconds: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(spacing: 24) {
                            recipeHeaderView(recipe: recipe)
                            quickStatsView(recipe: recipe)
                            ingredientsSection(recipe: recipe)
                            instructionsSection(recipe: recipe)
                            nutritionSection(recipe: recipe)
                            actionButtonsView(recipe: recipe)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.textSecondary)
                        Text("Recipe not found")
                            .font(AppFonts.subtitle(20))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(AppColors.textPrimary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if let recipe = recipe {
                    HStack {
                        Button(action: {
                            var updated = recipe
                            updated.isLiked.toggle()
                            self.recipe = updated
                            onUpdate(updated)
                        }) {
                            Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                                .foregroundColor(recipe.isLiked ? .red : AppColors.textPrimary)
                        }
                        
                        Button(action: {
                            var updated = recipe
                            updated.isInWishlist.toggle()
                            self.recipe = updated
                            onUpdate(updated)
                        }) {
                            Image(systemName: recipe.isInWishlist ? "bookmark.fill" : "bookmark")
                                .foregroundColor(recipe.isInWishlist ? AppColors.primaryYellow : AppColors.textPrimary)
                        }
                    }
                }
            }
        }
        .onAppear {
            recipe = recipeProvider(recipeId)
        }
        .sheet(isPresented: $showingTimer) {
            TimerView(totalSeconds: timerSeconds)
        }
    }
    
    private func recipeHeaderView(recipe: Recipe) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(recipe.name)
                    .font(AppFonts.title(24))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                HStack {
                    ForEach(recipe.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(AppFonts.caption(12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.primaryYellow)
                            )
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func quickStatsView(recipe: Recipe) -> some View {
        HStack(spacing: 0) {
            statItem(icon: "clock", title: "Time", value: "\(recipe.cookingTime)m")
            
            Divider()
                .frame(height: 40)
                .background(AppColors.cardBorder)
            
            statItem(icon: "flame", title: "Calories", value: "\(recipe.calories)")
            
            Divider()
                .frame(height: 40)
                .background(AppColors.cardBorder)
            
            statItem(icon: "chart.bar", title: "Level", value: recipe.difficulty.rawValue)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.subtitle(14))
                .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func ingredientsSection(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ingredients")
                    .font(AppFonts.subtitle(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(recipe.ingredients.count) items")
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 8, height: 8)
                        
                        Text(ingredient.name)
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Text("\(ingredient.amount) \(ingredient.unit)")
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func instructionsSection(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(AppFonts.subtitle(20))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(currentStep >= index ? AppColors.primaryYellow : AppColors.cardBackground)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            
                            Text("\(index + 1)")
                                .font(AppFonts.subtitle(14))
                                .foregroundColor(currentStep >= index ? .black : AppColors.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(instruction)
                                .font(AppFonts.body(16))
                                .foregroundColor(AppColors.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if index < recipe.instructions.count - 1 {
                                Button(currentStep == index ? "Complete Step" : "Start Step") {
                                    if currentStep == index {
                                        currentStep += 1
                                    } else {
                                        currentStep = index
                                    }
                                }
                                .font(AppFonts.caption(12))
                                .foregroundColor(AppColors.primaryYellow)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func nutritionSection(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutrition Facts")
                .font(AppFonts.subtitle(20))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 0) {
                macroItem(title: "Protein", value: "\(Int(recipe.macros.protein))g", color: AppColors.secondaryGreen)
                macroItem(title: "Carbs", value: "\(Int(recipe.macros.carbs))g", color: AppColors.secondaryOrange)
                macroItem(title: "Fat", value: "\(Int(recipe.macros.fat))g", color: AppColors.secondaryPink)
                macroItem(title: "Fiber", value: "\(Int(recipe.macros.fiber))g", color: AppColors.secondaryPurple)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func macroItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.subtitle(14))
                .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func shareRecipe(_ recipe: Recipe) {
        var lines: [String] = [
            recipe.name,
            "Category: \(recipe.category.rawValue)",
            "Time: \(recipe.cookingTime) min | Calories: \(recipe.calories) | Difficulty: \(recipe.difficulty.rawValue)",
            "",
            "--- Ingredients ---"
        ]
        for ing in recipe.ingredients {
            lines.append("  \(ing.name): \(ing.amount) \(ing.unit)")
        }
        lines.append("")
        lines.append("--- Instructions ---")
        for (idx, step) in recipe.instructions.enumerated() {
            lines.append("\(idx + 1). \(step)")
        }
        lines.append("")
        lines.append("--- Nutrition (per serving) ---")
        lines.append("Protein: \(Int(recipe.macros.protein))g | Carbs: \(Int(recipe.macros.carbs))g | Fat: \(Int(recipe.macros.fat))g | Fiber: \(Int(recipe.macros.fiber))g")
        if !recipe.tags.isEmpty {
            lines.append("Tags: \(recipe.tags.joined(separator: ", "))")
        }
        lines.append("")
        lines.append("Shared from CookHer")
        ShareHelper.presentShareSheet(items: [lines.joined(separator: "\n")])
    }
    
    private func actionButtonsView(recipe: Recipe) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    shareRecipe(recipe)
                } label: {
                    Text("Share Recipe")
                        .font(AppFonts.button(14))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
            }
        }
    }
}

struct TimerView: View {
    let totalSeconds: Int
    @Environment(\.dismiss) private var dismiss
    
    @State private var remainingSeconds: Int
    @State private var isRunning = false
    @State private var timer: Timer?
    
    init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
        self._remainingSeconds = State(initialValue: totalSeconds)
    }
    
    private var timeString: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Text(timeString)
                        .font(.system(size: 64, weight: .medium, design: .monospaced))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(remainingSeconds == 0 ? "Done" : (isRunning ? "Cooking..." : "Paused"))
                        .font(AppFonts.subtitle(18))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 16) {
                        if remainingSeconds > 0 {
                            Button(isRunning ? "Pause" : "Start") {
                                toggleTimer()
                            }
                            .font(AppFonts.button(16))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                    .fill(AppColors.primaryYellow)
                            )
                        }
                        
                        Button("Reset") {
                            resetTimer()
                        }
                        .font(AppFonts.button(16))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .navigationTitle("Cooking Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        timer?.invalidate()
                        timer = nil
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    timer?.invalidate()
                    timer = nil
                    isRunning = false
                }
            }
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingSeconds = totalSeconds
    }
}

#Preview {
    RecipeDetailView(
        recipeId: UUID(),
        recipeProvider: { _ in nil },
        onUpdate: { _ in }
    )
}
