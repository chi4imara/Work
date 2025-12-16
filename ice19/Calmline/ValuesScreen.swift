import SwiftUI

struct ValuesScreen: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAddPrinciple = false
    @State private var showingAddPhrase = false
    @State private var newPrincipleText = ""
    @State private var newPhraseText = ""
    @State private var dailyPhrase = ""
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    dailyPhraseSection
                    
                    principlesSection
                    
                    supportPhrasesSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
        .onAppear {
            refreshDailyPhrase()
        }
        .sheet(isPresented: $showingAddPrinciple) {
            AddTextSheet(
                title: "Add Principle",
                placeholder: "I don't have to control everything...",
                text: $newPrincipleText
            ) {
                if !newPrincipleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    dataManager.addUserValue(newPrincipleText.trimmingCharacters(in: .whitespacesAndNewlines))
                    newPrincipleText = ""
                }
            }
        }
        .sheet(isPresented: $showingAddPhrase) {
            AddTextSheet(
                title: "Add Support Phrase",
                placeholder: "I'm managing...",
                text: $newPhraseText
            ) {
                if !newPhraseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    dataManager.addSupportPhrase(newPhraseText.trimmingCharacters(in: .whitespacesAndNewlines))
                    newPhraseText = ""
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
            
            Spacer()
            
            Text("My Values")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
        }
    }
    
    private var dailyPhraseSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Daily Reminder")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Spacer()
                
                Button("Refresh") {
                    refreshDailyPhrase()
                }
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.shared.primaryPurple)
            }
            
            VStack(spacing: 12) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 40))
                    .foregroundColor(ColorManager.shared.primaryYellow)
                
                Text(dailyPhrase)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.shared.primaryWhite)
                    .shadow(color: ColorManager.shared.primaryYellow.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var principlesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Principles")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Spacer()
                
                Button(action: {
                    showingAddPrinciple = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.shared.primaryPurple)
                }
            }
            
            if dataManager.userValues.isEmpty {
                emptyStateView(
                    message: "Add a few phrases that remind you who you are and how you want to live your days.",
                    buttonTitle: "Create First Phrase",
                    action: { showingAddPrinciple = true }
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(dataManager.userValues) { value in
                        ValueCard(
                            text: value.text,
                            onDelete: {
                                dataManager.deleteUserValue(value)
                            }
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var supportPhrasesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Support Phrases")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Spacer()
                
                Button(action: {
                    showingAddPhrase = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.shared.primaryPurple)
                }
            }
            
            if dataManager.supportPhrases.isEmpty {
                emptyStateView(
                    message: "Add short personal affirmations that support you.",
                    buttonTitle: "Add First Phrase",
                    action: { showingAddPhrase = true }
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(dataManager.supportPhrases) { phrase in
                        ValueCard(
                            text: phrase.text,
                            onDelete: {
                                dataManager.deleteSupportPhrase(phrase)
                            }
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func emptyStateView(message: String, buttonTitle: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.shared.darkGray.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                action()
            } label: {
                Text(buttonTitle)
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(ColorManager.shared.primaryYellow)
                    .cornerRadius(16)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func refreshDailyPhrase() {
        dailyPhrase = dataManager.getRandomInspirationalPhrase()
    }
}

struct CardHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ValueCard: View {
    let text: String
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isDeleteVisible = false
    @State private var cardHeight: CGFloat = 0
    
    private let deleteButtonWidth: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Button(action: onDelete) {
                HStack {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .frame(width: deleteButtonWidth)
                .frame(height: cardHeight > 0 ? cardHeight : nil)
                .background(ColorManager.shared.accentPink)
            }
            .opacity(offset < 0 ? 1 : 0)
            
            HStack {
                Text(text)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(2)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorManager.shared.primaryWhite)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: CardHeightPreferenceKey.self, value: geometry.size.height)
                }
            )
            .onPreferenceChange(CardHeightPreferenceKey.self) { height in
                cardHeight = height
            }
            .offset(x: offset)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = max(value.translation.width, -deleteButtonWidth)
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -50 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isDeleteVisible = true
                                offset = -deleteButtonWidth
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isDeleteVisible = false
                                offset = 0
                            }
                        }
                    }
            )
            .onTapGesture {
                if isDeleteVisible {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isDeleteVisible = false
                        offset = 0
                    }
                }
            }
        }
        .cornerRadius(10)
        .clipped()
    }
}

struct AddTextSheet: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.shared.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Add something that inspires and supports you")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.shared.cardGradient)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        
                        TextEditor(text: $text)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorManager.shared.darkGray)
                            .padding(16)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                        
                        if text.isEmpty {
                            Text(placeholder)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.shared.darkGray.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 24)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(height: 120)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }
}

#Preview {
    ValuesScreen()
        .environmentObject(DataManager.shared)
}
