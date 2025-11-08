import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    calendarGridView
                    
                    selectedDateView
                    
                    moviesListView
                    
                    Spacer()
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                viewModel.moveToPreviousMonth()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
            
            Text(viewModel.monthYearString)
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                viewModel.moveToNextMonth()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.lightGray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            let days = viewModel.getDaysInMonth()
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<days.count, id: \.self) { index in
                    let date = days[index]
                    
                    if date == Date.distantPast {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50)
                    } else {
                        CalendarDayView(
                            date: date,
                            movieCount: viewModel.getMovieCount(for: date),
                            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                            isToday: Calendar.current.isDateInToday(date)
                        ) {
                            viewModel.selectDate(date)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var selectedDateView: some View {
        VStack(spacing: 8) {
            Text(viewModel.selectedDateString)
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text("\(viewModel.moviesForSelectedDate.count) movies watched")
                .font(FontManager.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var moviesListView: some View {
            if viewModel.moviesForSelectedDate.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.lightGray)
                    
                    Text("No movies watched on this day")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.lightGray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.moviesForSelectedDate, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie, viewModel: MoviesViewModel())) {
                            CalendarMovieCardView(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
    }
}

struct CalendarDayView: View {
    let date: Date
    let movieCount: Int
    let isSelected: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(FontManager.subheadline)
                    .foregroundColor(textColor)
                    .fontWeight(isToday ? .bold : .regular)
                
                if movieCount > 0 {
                    Text("\(movieCount)")
                        .font(FontManager.caption2)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.05, green: 0.05, blue: 0.1).opacity(0.2))
                        )
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return AppColors.background
        } else if isToday {
            return AppColors.primaryText
        } else {
            return AppColors.secondaryText
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.primaryText
        } else if movieCount > 0 {
            return AppColors.cardBackground
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isToday && !isSelected {
            return AppColors.primaryText
        } else {
            return AppColors.primaryText
        }
    }
}

struct CalendarMovieCardView: View {
    let movie: Movie
    
    var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(movie.genre)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if !movie.shortReview.isEmpty && movie.shortReview != "No review" {
                        Text(movie.shortReview)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(movie.ratingText)
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.primaryText.opacity(0.2))
                        )
                    
                    Button(action: {
                        let tempViewModel = MoviesViewModel()
                        tempViewModel.toggleFavorite(movie)
                    }) {
                        Image(systemName: movie.isFavorite ? "star.fill" : "star")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(movie.isFavorite ? AppColors.warning : AppColors.lightGray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            )
    }
}

#Preview {
    CalendarView()
}
