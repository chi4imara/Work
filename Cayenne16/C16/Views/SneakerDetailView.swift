import SwiftUI

struct SneakerDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    let sneaker: Sneaker
    @State private var currentSneaker: Sneaker
    @State private var newWearingDate = Date()
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    init(sneaker: Sneaker) {
        self.sneaker = sneaker
        self._currentSneaker = State(initialValue: sneaker)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(currentSneaker.model)
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            DetailRow(title: "Purchase Date", value: dateFormatter.string(from: currentSneaker.purchaseDate))
                            DetailRow(title: "Condition", value: currentSneaker.condition.rawValue)
                            DetailRow(
                                title: "Comment",
                                value: currentSneaker.comment.isEmpty ? "No comment added." : currentSneaker.comment
                            )
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(ColorManager.cardGradient)
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mark Wearing")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            VStack(spacing: 12) {
                                DatePicker("Wearing Date", selection: $newWearingDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .accentColor(ColorManager.lightBlue)
                                
                                Button(action: addWearingDate) {
                                    Text("Add")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(ColorManager.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(ColorManager.lightBlue)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(20)
                        .background(ColorManager.cardGradient)
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Wearing History")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            if currentSneaker.wearingDates.isEmpty {
                                Text("You haven't marked any wearing days yet.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.secondaryText)
                                    .padding(.vertical, 20)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(currentSneaker.wearingDates) { wearingDate in
                                        HStack {
                                            Text(dateFormatter.string(from: wearingDate.date))
                                                .font(.ubuntu(16))
                                                .foregroundColor(ColorManager.primaryText)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                removeWearingDate(wearingDate.id)
                                            }) {
                                                Text("Delete")
                                                    .font(.ubuntu(14, weight: .medium))
                                                    .foregroundColor(ColorManager.warningRed)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(ColorManager.warningRed.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        
                                        if wearingDate.id != currentSneaker.wearingDates.last?.id {
                                            Divider()
                                                .background(ColorManager.secondaryText.opacity(0.3))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(ColorManager.cardGradient)
                        .cornerRadius(16)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                Text("Edit")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            colors: [ColorManager.lightBlue, ColorManager.orange],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete Pair")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorManager.warningRed)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(ColorManager.warningRed.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            refreshSneaker()
        }
        .sheet(isPresented: $showingEditView) {
            EditSneakerView(sneaker: currentSneaker) { updatedSneaker in
                dataManager.updateSneaker(updatedSneaker)
                refreshSneaker()
            }
        }
        .alert("Delete Pair", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteSneaker(withId: currentSneaker.id)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this pair? This action cannot be undone.")
        }
    }
    
    private func addWearingDate() {
        dataManager.addWearingDate(to: currentSneaker.id, date: newWearingDate)
        refreshSneaker()
    }
    
    private func removeWearingDate(_ wearingDateId: UUID) {
        dataManager.removeWearingDate(from: currentSneaker.id, wearingDateId: wearingDateId)
        refreshSneaker()
    }
    
    private func refreshSneaker() {
        if let updated = dataManager.getSneaker(withId: currentSneaker.id) {
            currentSneaker = updated
        }
    }
}

#Preview {
    SneakerDetailView(
        sneaker: Sneaker(
            model: "Nike Air Max 270",
            purchaseDate: Date(),
            condition: .new,
            comment: "Great for running"
        )
    )
    .environmentObject(DataManager.shared)
}
