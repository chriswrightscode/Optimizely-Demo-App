//
//  OptimizelyManager.swift
//  Optimizely-Demo-App
//
//  Created by Christopher Wright on 11/1/25.
//

import Foundation
import Optimizely

@MainActor
class OptimizelyManager: ObservableObject {
    static let shared = OptimizelyManager()
    
    private var optimizelyClient: OptimizelyClient?
    private let sdkKey = "TfAtdtiXXWjsiiqHH5zHt"
    
    @Published var isInitialized = false
    
    private init() {}
    
    func initialize() async {
        guard !isInitialized else { return }
        
        optimizelyClient = OptimizelyClient(sdkKey: sdkKey)
        
        // Start the SDK (downloads the datafile)
        // The start method is asynchronous and returns a Result
        await withCheckedContinuation { continuation in
            optimizelyClient?.start { result in
                switch result {
                case .success:
                    Task { @MainActor in
                        self.isInitialized = true
                        continuation.resume()
                    }
                case .failure(let error):
                    print("Error initializing Optimizely: \(error)")
                    continuation.resume()
                }
            }
        }
    }
    
    func checkUserCategoryAccess(flagKey: String, userCategory: String, jsonVariableKey: String) -> Bool {
        guard let client = optimizelyClient, isInitialized else { return false }
        
        let decision = client.createUserContext(userId: UUID().uuidString, attributes: [:])
            .decide(key: flagKey)
        
        guard let allowedCategoriesValue = decision.variables.toMap()[jsonVariableKey] else {
            print("Could not find JSON variable '\(jsonVariableKey)' in variables map")
            return false
        }
        
        guard let categories = extractUserTypes(from: allowedCategoriesValue) else {
            print("Could not extract userTypes array from JSON variable")
            return false
        }
        
        let normalizedUserCategory = userCategory.lowercased()
        let normalizedCategories = categories.map { $0.lowercased() }
        
        print("Checking if '\(normalizedUserCategory)' is in allowed categories: \(normalizedCategories)")
        return normalizedCategories.contains(normalizedUserCategory)
    }
    
    private func extractUserTypes(from value: Any) -> [String]? {
        if let jsonDict = value as? [String: Any],
           let userTypes = jsonDict["userTypes"] as? [String] {
            return userTypes
        }
        
        return nil
    }
}

