import SwiftUI

struct EntryDetailView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appColors = AppColors.shared
    @Environment(\.presentationMode) var presentationMode
    
    let entry: MoodEntry
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        ZStack {
            appColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    dateTimeHeader
                    
                    weatherCard
                    
                    moodCard
                    
                    if let location = entry.location {
                        locationCard(location)
                    }
                    
                    if let tag = entry.tag {
                        tagCard(tag)
                    }
                    
                    if let comment = entry.comment {
                        commentCard(comment)
                    }
                    
                    actionButtons
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(appColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditEntry(entry: entry)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private var dateTimeHeader: some View {
        VStack(spacing: 8) {
            Text(entry.displayDate)
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(appColors.textPrimary)
            
            if let timeString = entry.displayTime {
                Text(timeString)
                    .font(.builderSans(.medium, size: 18))
                    .foregroundColor(appColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var weatherCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(appColors.primaryGradient)
                    .frame(width: 60, height: 60)
                
                Image(systemName: entry.weather.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Weather")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(appColors.textSecondary)
                
                Text(entry.weather.displayName)
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(appColors.textPrimary)
                
                Text("\(String(format: "%.1f", entry.temperature))°C")
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(appColors.primaryBlue)
            }
            
            Spacer()
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var moodCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(appColors.buttonGradient)
                    .frame(width: 60, height: 60)
                
                Image(systemName: entry.mood.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Mood")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(appColors.textSecondary)
                
                Text(entry.mood.displayName)
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(appColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func locationCard(_ location: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(appColors.accentGreen)
                
                Text("Location")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(appColors.textSecondary)
                
                Spacer()
            }
            
            Text(location)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func tagCard(_ tag: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(appColors.accentPurple)
                
                Text("Tag")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(appColors.textSecondary)
                
                Spacer()
            }
            
            Text(tag)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func commentCard(_ comment: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(appColors.accentPink)
                
                Text("Comment")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(appColors.textSecondary)
                
                Spacer()
            }
            
            Text(comment)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.textPrimary)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: appColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Entry")
                        .font(.builderSans(.semiBold, size: 18))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(appColors.primaryGradient)
                .cornerRadius(28)
                .shadow(color: appColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Entry")
                        .font(.builderSans(.medium, size: 16))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(appColors.cardGradient)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private func deleteEntry() {
        dataManager.deleteEntry(entry)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        EntryDetailView(entry: MoodEntry(
            date: Date(),
            time: Date(),
            weather: .sunny,
            temperature: 22.5,
            mood: .happy,
            location: "New York",
            tag: "Great day",
            comment: "Had a wonderful day with friends. The weather was perfect for a walk in the park."
        ))
    }
}
