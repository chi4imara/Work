import SwiftUI

struct PeopleView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddPerson = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("People")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if dataManager.people.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "person.2")
                            .font(.system(size: 60))
                            .foregroundColor(.appTextSecondary)
                        
                        Text("Here you will see people you add gift ideas for.")
                            .font(.ubuntu(16))
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            showingAddPerson = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add person")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appAccent)
                            )
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dataManager.people) { person in
                                NavigationLink(destination: GiftIdeasView(personId: person.id)) {
                                    PersonCard(person: person)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 180)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingAddPerson = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add person")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appAccent)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 80)
                }
            }
        }
        .sheet(isPresented: $showingAddPerson) {
            AddPersonView()
        }
    }
}

struct PersonCard: View {
    let person: Person
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                Text("\(person.ideaCount) ideas")
                    .font(.ubuntu(14))
                    .foregroundColor(.appTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.appTextSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard)
        )
    }
}

#Preview {
    PeopleView()
}
