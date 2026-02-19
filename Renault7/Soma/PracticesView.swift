import SwiftUI

struct PracticesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddPractice = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Practices")
                        .font(.playfair(24, weight: .bold))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddPractice = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(ColorTheme.accentColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if dataManager.practices.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "heart.circle")
                            .font(.system(size: 80))
                            .foregroundColor(ColorTheme.secondaryColor)
                        
                        VStack(spacing: 12) {
                            Text("Add Your First Practice")
                                .font(.playfair(24, weight: .bold))
                                .foregroundColor(ColorTheme.textColor)
                            
                            Text("Create body care practices that fit into your daily routine")
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.secondaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        Button(action: {
                            showingAddPractice = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Practice")
                            }
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 56)
                            .background(ColorTheme.accentColor)
                            .cornerRadius(16)
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(dataManager.practices) { practice in
                                NavigationLink(destination: PracticeDetailView(practiceId: practice.id)) {
                                    PracticeCard(practice: practice)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeView()
        }
    }
}

struct PracticeCard: View {
    let practice: Practice
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.accentColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: practice.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(practice.name)
                    .font(.playfair(18, weight: .medium))
                    .foregroundColor(ColorTheme.textColor)
                
                Text(practice.type.rawValue)
                    .font(.playfair(14))
                    .foregroundColor(ColorTheme.secondaryColor)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(ColorTheme.secondaryColor)
                    
                    Text("\(practice.duration) min")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryColor)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(practice.streak)")
                    .font(.playfair(20, weight: .bold))
                    .foregroundColor(ColorTheme.accentColor)
                
                Text("day streak")
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryColor)
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    PracticesView()
        .environmentObject(DataManager.shared)
}
