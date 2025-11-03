//
//  ContentView.swift
//  Optimizely-Demo-App
//
//  Created by Christopher Wright on 11/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var optimizelyManager = OptimizelyManager.shared
    @State private var isLoading = true
    @State private var selectedUserCategory: String?
    @State private var hasAccess = false
    
    // Feature flag key - update this to match your Optimizely feature flag key
    private let featureFlagKey = "demo_feature_flag"
    // JSON variable key - update this to match your Optimizely JSON variable key
    private let jsonVariableKey = "allowed_categories"
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    // Loading state
                    VStack {
                        ProgressView()
                        Text("Initializing Optimizely...")
                            .padding(.top)
                            .foregroundColor(.secondary)
                    }
                } else if selectedUserCategory == nil {
                    // User category selection screen
                    UserCategorySelectionView { category in
                        selectedUserCategory = category
                        checkUserAccess(category: category)
                    }
                } else {
                    // Result screen
                    UserAccessResultView(
                        userCategory: selectedUserCategory ?? "",
                        hasAccess: hasAccess
                    ) {
                        // Reset button action
                        selectedUserCategory = nil
                        hasAccess = false
                    }
                }
            }
        }
        .task {
            await optimizelyManager.initialize()
            
            // Wait a moment for initialization to complete
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            isLoading = false
        }
    }
    
    private func checkUserAccess(category: String) {
        hasAccess = optimizelyManager.checkUserCategoryAccess(
            flagKey: featureFlagKey,
            userCategory: category,
            jsonVariableKey: jsonVariableKey
        )
    }
}

struct UserCategorySelectionView: View {
    let onCategorySelected: (String) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Select Your User Category")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            Button(action: {
                onCategorySelected("premium")
            }) {
                Text("Premium User")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            
            Button(action: {
                onCategorySelected("gold")
            }) {
                Text("Gold User")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            
            Button(action: {
                onCategorySelected("silver")
            }) {
                Text("Silver User")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct UserAccessResultView: View {
    let userCategory: String
    let hasAccess: Bool
    let onReset: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            if hasAccess {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("User category found. Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Category: \(userCategory.capitalized)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                
                Text("Content is hidden for silver members")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Category: \(userCategory.capitalized)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Button(action: onReset) {
                Text("Back to Selection")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
