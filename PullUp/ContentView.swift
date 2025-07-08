//
//  ContentView.swift
//  PullUp
//
//  Created by Marcus Kim on 7/1/25.
//

import SwiftUI
import Inject

enum AppScreen {
    case splash, onboarding, swipe, filters, match(User), chat(Match), chatsList
}

struct ContentView: View { 
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var filtersViewModel = FiltersViewModel()
    @State private var currentScreen: AppScreen = .splash
    @State private var currentUserID: UUID? = AppConfig.isDemoMode ? AppConfig.demoUserID : nil
    @State private var matchedUser: User? = nil
    @State private var activeMatch: Match? = nil
    @State private var previousScreen: AppScreen = .splash

    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashView {
                    currentScreen = .onboarding
                }
            case .onboarding:
                OnboardingView {
                    // After onboarding, set user ID and go to swipe
                    if AppConfig.isDemoMode {
                        currentUserID = AppConfig.demoUserID
                    } else {
                        // In a real app, fetch the user ID from Supabase Auth/session
                        // currentUserID = ...
                    }
                    currentScreen = .swipe
                }
            case .swipe:
                if let userID = currentUserID {
                    SwipeView(
                        currentUserID: userID,
                        onMatch: { user in
                            matchedUser = user
                            previousScreen = .swipe
                            currentScreen = .match(user)
                        },
                        onFilters: {
                            previousScreen = .swipe
                            currentScreen = .filters
                        }
                    )
                } else {
                    Text("User not found. Please log in again.")
                        .foregroundColor(.red)
                }
            case .filters:
                FiltersView(viewModel: filtersViewModel) {
                    currentScreen = .swipe
                }
            case .match(let user):
                MatchView(
                    matchedUser: user,
                    onSendMessage: {
                        // In a real app, find or create the match and go to chat
                        if let match = activeMatch {
                            previousScreen = .match(user)
                            currentScreen = .chat(match)
                        } else if AppConfig.isDemoMode {
                            // For demo, create a dummy match
                            let match = Match(id: UUID(), user1_id: currentUserID ?? AppConfig.demoUserID, user2_id: user.id, timestamp: Date())
                            activeMatch = match
                            previousScreen = .match(user)
                            currentScreen = .chat(match)
                        }
                    },
                    onKeepSwiping: {
                        currentScreen = .swipe
                    }
                )
            case .chat(let match):
                if let userID = currentUserID {
                    ChatView(
                        matchID: match.id, 
                        senderID: userID,
                        onBack: {
                            currentScreen = previousScreen
                        }
                    )
                } else {
                    Text("User not found. Please log in again.")
                        .foregroundColor(.red)
                }
            case .chatsList:
                if let userID = currentUserID {
                    ChatsListView(currentUserID: userID) { match in
                        previousScreen = .chatsList
                        currentScreen = .chat(match)
                    }
                } else {
                    Text("User not found. Please log in again.")
                        .foregroundColor(.red)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
