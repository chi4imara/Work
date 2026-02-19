import SwiftUI

struct WatchDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @State var watch: Watch
    @ObservedObject var viewModel: WatchViewModel
    @Binding var isPresented: Bool
    @State private var selectedWearingDate = Date()
    @State private var showingEditWatch = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            Button("Close") {
                                isPresented = false
                            }
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text(watch.name)
                                .font(.playfairDisplay(size: 20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            Text("Close")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(Color.clear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            WatchDetailRow(title: "Purchase Date", value: formatDate(watch.purchaseDate))
                            WatchDetailRow(title: "Style", value: watch.style.displayName)
                            WatchDetailRow(title: "Condition", value: watch.condition.displayName)
                            WatchDetailRow(
                                title: "Comment",
                                value: watch.comment.isEmpty ? "No comment added." : watch.comment
                            )
                        }
                        .padding(20)
                        .background(ColorManager.cardGradient)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mark Wearing")
                                .font(.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            VStack(spacing: 12) {
                                DatePicker("Wearing Date", selection: $selectedWearingDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .colorInvert()
                                    .accentColor(ColorManager.lightBlue)
                                    .padding()
                                    .background(ColorManager.cardGradient)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                                
                                Button(action: addWearingDay) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 16))
                                        
                                        Text("Add Day")
                                            .font(.playfairDisplay(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(ColorManager.green)
                                    .cornerRadius(22)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Wearing History")
                                .font(.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            if watch.wearingDays.isEmpty {
                                Text("You haven't marked any wearing days yet.")
                                    .font(.playfairDisplay(size: 16, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 30)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(watch.wearingDays.sorted(by: { $0.date > $1.date })) { wearingDay in
                                        WearingDayRow(
                                            wearingDay: wearingDay,
                                            onDelete: {
                                                removeWearingDay(wearingDay)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditWatch = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Edit")
                                        .font(.playfairDisplay(size: 18, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [ColorManager.lightBlue, ColorManager.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(28)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Delete Watch")
                                        .font(.playfairDisplay(size: 18, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(ColorManager.red)
                                .cornerRadius(28)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditWatch) {
            EditWatchView(
                watch: $watch,
                viewModel: viewModel,
                isPresented: $showingEditWatch
            )
        }
        .alert("Delete Watch", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteWatch(watch)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this watch? This action cannot be undone.")
        }
    }
    
    private func addWearingDay() {
        viewModel.addWearingDay(to: watch.id, date: selectedWearingDate)
        if let updatedWatch = viewModel.getWatch(by: watch.id) {
            watch = updatedWatch
        }
    }
    
    private func removeWearingDay(_ wearingDay: WearingDay) {
        viewModel.removeWearingDay(from: watch.id, wearingDayId: wearingDay.id)
        if let updatedWatch = viewModel.getWatch(by: watch.id) {
            watch = updatedWatch
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct WearingDayRow: View {
    let wearingDay: WearingDay
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.system(size: 16))
                .foregroundColor(ColorManager.lightBlue)
            
            Text(formatDate(wearingDay.date))
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(ColorManager.red)
            }
        }
        .padding()
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    WatchDetailsView(
        watch: Watch(
            name: "Casio Edifice",
            purchaseDate: Date(),
            style: .sport,
            condition: .new,
            comment: "Birthday gift"
        ),
        viewModel: WatchViewModel(),
        isPresented: .constant(true)
    )
}
