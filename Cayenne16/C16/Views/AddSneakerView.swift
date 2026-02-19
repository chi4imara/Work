import SwiftUI

struct AddSneakerView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var model = ""
    @State private var purchaseDate = Date()
    @State private var selectedCondition = SneakerCondition.new
    @State private var comment = ""
    @State private var showingSuccessView = false
    @State private var lastAddedSneaker: Sneaker?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Add Pair")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Model")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Enter sneaker model", text: $model)
                                .font(.ubuntu(16))
                                .padding(16)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(12)
                                .foregroundColor(ColorManager.primaryText)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purchase Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(16)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorManager.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Condition")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Menu {
                                ForEach(SneakerCondition.allCases, id: \.self) { condition in
                                    Button(condition.rawValue) {
                                        selectedCondition = condition
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCondition.rawValue)
                                        .font(.ubuntu(16))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(ColorManager.secondaryText)
                                }
                                .padding(16)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Optional comment", text: $comment, axis: .vertical)
                                .font(.ubuntu(16))
                                .lineLimit(3...6)
                                .padding(16)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(12)
                                .foregroundColor(ColorManager.primaryText)
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    Button(action: saveSneaker) {
                        Text("Save")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                AnyShapeStyle(ColorManager.buttonBackground) :
                                    AnyShapeStyle(LinearGradient(
                                        colors: [ColorManager.lightBlue, ColorManager.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                            .cornerRadius(16)
                    }
                    .disabled(model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .sheet(isPresented: $showingSuccessView) {
            if let sneaker = lastAddedSneaker {
                SneakerAddedView(sneaker: sneaker) {
                    showingSuccessView = false
                    clearForm()
                }
            }
        }
    }
    
    private func saveSneaker() {
        let trimmedModel = model.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedModel.isEmpty else { return }
        
        let newSneaker = Sneaker(
            model: trimmedModel,
            purchaseDate: purchaseDate,
            condition: selectedCondition,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        dataManager.addSneaker(newSneaker)
        lastAddedSneaker = newSneaker
        showingSuccessView = true
    }
    
    private func clearForm() {
        model = ""
        purchaseDate = Date()
        selectedCondition = .new
        comment = ""
    }
}

#Preview {
    AddSneakerView()
        .environmentObject(DataManager.shared)
}
