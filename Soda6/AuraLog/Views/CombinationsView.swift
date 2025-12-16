import SwiftUI

struct CombinationsView: View {
    @ObservedObject var store: PerfumeStore
    @State private var showingAddCombination = false
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorite Combinations")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showingAddCombination = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if store.combinations.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.primaryYellow.opacity(0.6))
                        
                        VStack(spacing: 12) {
                            Text("No combinations yet")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(.primaryText)
                            
                            Text("Add your first ideas to create your own fragrance combinations.")
                                .font(.ubuntu(16))
                                .foregroundColor(.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: { showingAddCombination = true }) {
                            Text("Add Combination")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.primaryText)
                                .frame(width: 200, height: 50)
                                .background(AppGradients.yellowGradient)
                                .cornerRadius(25)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.combinations) { combination in
                                CombinationCardView(
                                    combination: combination,
                                    onDelete: {
                                        store.deleteCombination(combination)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCombination) {
            AddCombinationView(store: store)
        }
    }
}

struct CombinationCardView: View {
    let combination: Combination
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(combination.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .lineLimit(2)
                    
                    Text(DateFormatter.shortDate.string(from: combination.dateAdded))
                        .font(.ubuntu(12))
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.accentPink)
                }
            }
            
            if !combination.comment.isEmpty {
                Text(combination.comment)
                    .font(.ubuntu(15))
                    .foregroundColor(.secondaryText)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .background(AppGradients.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .alert("Delete Combination", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(combination.name)\"?")
        }
    }
}

struct AddCombinationView: View {
    @ObservedObject var store: PerfumeStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var comment = ""
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Combination Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.primaryText)
                            
                            TextField("e.g., Vanilla + Oud", text: $name)
                                .font(.ubuntu(16))
                                .foregroundColor(.primaryText)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.primaryText)
                            
                            TextField("Describe this combination...", text: $comment, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(.primaryText)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .lineLimit(3...8)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: saveCombination) {
                        Text("Save Combination")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(canSave ? .primaryText : .secondaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSave ? AnyShapeStyle(AppGradients.yellowGradient) : AnyShapeStyle(Color.surfaceBackground))
                            .cornerRadius(25)
                    }
                    .disabled(!canSave)
                }
                .padding(20)
            }
            .navigationTitle("Add Combination")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveCombination() {
        let newCombination = Combination(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        store.addCombination(newCombination)
        presentationMode.wrappedValue.dismiss()
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
