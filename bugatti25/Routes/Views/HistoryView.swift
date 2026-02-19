import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedDate = Date()
    @State private var showingCalendar = false
    
    private let calendar = Calendar.current
    
    var completedItemsForSelectedDate: [AnyItem] {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        var items: [AnyItem] = []
        
        let completedPlaces = viewModel.places.filter { place in
            guard let completionDate = place.completionDate else { return false }
            return completionDate >= startOfDay && completionDate < endOfDay
        }
        items.append(contentsOf: completedPlaces.map { AnyItem.place($0) })
        
        let completedTasks = viewModel.dailyTasks.filter { task in
            guard let completionDate = task.completionDate else { return false }
            return completionDate >= startOfDay && completionDate < endOfDay
        }
        items.append(contentsOf: completedTasks.map { AnyItem.task($0) })
        
        let completedChallenges = viewModel.completedChallenges.filter { challenge in
            guard let completionDate = challenge.completionDate else { return false }
            return completionDate >= startOfDay && completionDate < endOfDay
        }
        
        return items
    }
    
    var streakDays: Int {
        var streak = 0
        var currentDate = Date()
        
        while streak < 365 { 
            let startOfDay = calendar.startOfDay(for: currentDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let hasActivity = viewModel.places.contains { place in
                guard let completionDate = place.completionDate else { return false }
                return completionDate >= startOfDay && completionDate < endOfDay
            } || viewModel.dailyTasks.contains { task in
                guard let completionDate = task.completionDate else { return false }
                return completionDate >= startOfDay && completionDate < endOfDay
            }
            
            if hasActivity {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        HStack {
                            Text("History")
                                .font(.playfairDisplay(.bold, size: 28))
                                .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            Button(action: {
                                showingCalendar.toggle()
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title2)
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Streak",
                                value: "\(streakDays)",
                                subtitle: "days",
                                icon: "flame.fill",
                                color: .primaryYellow
                            )
                            
                            StatCard(
                                title: "Places",
                                value: "\(viewModel.places.filter { $0.isCompleted }.count)",
                                subtitle: "visited",
                                icon: "location.fill",
                                color: .primaryBlue
                            )
                            
                            StatCard(
                                title: "Tasks",
                                value: "\(viewModel.dailyTasks.filter { $0.isCompleted }.count)",
                                subtitle: "completed",
                                icon: "checkmark.circle.fill",
                                color: .successGreen
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate)!
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(.primaryBlue)
                            }
                            
                            Spacer()
                            
                            Text(selectedDate, style: .date)
                                .font(.playfairDisplay(.semibold, size: 18))
                                .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            Button(action: {
                                let tomorrow = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
                                if tomorrow <= Date() {
                                    selectedDate = tomorrow
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(calendar.date(byAdding: .day, value: 1, to: selectedDate)! <= Date() ? .primaryBlue : .textLight)
                            }
                            .disabled(calendar.date(byAdding: .day, value: 1, to: selectedDate)! > Date())
                        }
                        .padding(.horizontal, 20)
                        
                        if completedItemsForSelectedDate.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(.textLight)
                                
                                Text("No activities on this day")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(40)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(completedItemsForSelectedDate, id: \.id) { item in
                                        HistoryItemView(item: item)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarView(selectedDate: $selectedDate, viewModel: viewModel)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(.primaryBlue)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.playfairDisplay(.medium, size: 12))
                    .foregroundColor(.textSecondary)
                
                Text(subtitle)
                    .font(.playfairDisplay(.regular, size: 10))
                    .foregroundColor(.textLight)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

struct HistoryItemView: View {
    let item: AnyItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundColor(.successGreen)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(itemTitle)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                
                HStack {
                    Image(systemName: categoryIcon)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(categoryName)
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    if let completionTime = completionTime {
                        Text(completionTime)
                            .font(.playfairDisplay(.regular, size: 12))
                            .foregroundColor(.textLight)
                    }
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.successGreen.opacity(0.1))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.successGreen.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private var itemTitle: String {
        switch item {
        case .place(let place):
            return place.name
        case .task(let task):
            return task.title
        }
    }
    
    private var categoryName: String {
        switch item {
        case .place(let place):
            return place.category.rawValue
        case .task(let task):
            return task.category.rawValue
        }
    }
    
    private var categoryIcon: String {
        switch item {
        case .place(let place):
            return place.category.icon
        case .task(let task):
            return task.category.icon
        }
    }
    
    private var completionTime: String? {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        switch item {
        case .place(let place):
            return place.completionDate.map { formatter.string(from: $0) }
        case .task(let task):
            return task.completionDate.map { formatter.string(from: $0) }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(.primaryYellow)
                }
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: AppViewModel())
}
