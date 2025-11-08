import SwiftUI

struct PersonSheetItem: Identifiable {
    let id = UUID()
    let name: String
}

struct PeopleView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @State private var selectedPerson: PersonSheetItem?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("People")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    if !viewModel.getTopPeopleByAmount().isEmpty {
                        TopSpendersView(people: viewModel.getTopPeopleByAmount())
                    }
                    
                    PeopleListView(
                        people: viewModel.getPeople(),
                        onPersonTapped: { person in
                            selectedPerson = PersonSheetItem(name: person.name)
                        }
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
                .padding(.top)
                
                
                if viewModel.giftIdeas.isEmpty {
                    EmptyPeopleView()
                }
            }
        }
        .sheet(item: $selectedPerson) { personItem in
            PersonGiftsView(personName: personItem.name, viewModel: viewModel)
        }
    }
}

struct TopSpendersView: View {
    let people: [Person]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Spenders")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Array(people.enumerated()), id: \.element.id) { index, person in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(rankColor(for: index))
                                .frame(width: 32, height: 32)
                            
                            Text("\(index + 1)")
                                .font(.theme.headline)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(person.name)
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("\(person.giftCount) gifts")
                                .font(.theme.caption)
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", person.totalAmount))
                            .font(.theme.title3)
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .padding(.vertical, 8)
                    
                    if index < people.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
    
    private func rankColor(for index: Int) -> Color {
        switch index {
        case 0: return Color.theme.accentOrange
        case 1: return Color.theme.primaryBlue
        case 2: return Color.theme.accentPurple
        default: return Color.theme.ideaColor
        }
    }
}

struct PeopleListView: View {
    let people: [Person]
    let onPersonTapped: (Person) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All People")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(people) { person in
                    PersonRowView(person: person) {
                        onPersonTapped(person)
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct PersonRowView: View {
    let person: Person
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.theme.lightBlue)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(person.name.prefix(1)).uppercased())
                            .font(.theme.title3)
                            .foregroundColor(Color.theme.primaryBlue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(person.name)
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryText)
                        .lineLimit(1)
                    
                    Text("\(person.giftCount) gifts")
                        .font(.theme.caption)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    if !person.lastGift.isEmpty {
                        Text("Last: \(person.lastGift)")
                            .font(.theme.caption2)
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if person.totalAmount > 0 {
                        Text(String(format: "$%.2f", person.totalAmount))
                            .font(.theme.headline)
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct EmptyPeopleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.2")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            Text("No people yet")
                .font(.theme.title2)
                .foregroundColor(Color.theme.primaryText)
            
            Text("Add your first gift idea to see people here")
                .font(.theme.body)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
}

struct PersonGiftsView: View {
    let personName: String
    @ObservedObject var viewModel: GiftIdeaViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.getGiftIdeas(for: personName)) { gift in
                            GiftIdeaCardView(gift: gift)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle("\(personName)'s Gifts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
}

