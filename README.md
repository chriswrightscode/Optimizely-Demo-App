# Optimizely-Demo-App
SwiftUI App demonstrating Optimizely Feature Flag controls

## Overview
This demonstration app showcases how to integrate Optimizely feature flags with SwiftUI. The app:
- Presents an initial screen with three user category buttons: **Premium User**, **Gold User**, and **Silver User**
- When a user category is selected, the app checks a JSON variable array from Optimizely
- Displays different UI based on whether the selected category is found in the JSON variable array:
  - **Category found in array**: "User category found. Welcome!" message
  - **Category not found**: "Content is hidden for silver members" message

## Setup Instructions

### 1. Add Optimizely Package Dependency
The Optimizely Swift SDK package should already be added to the project. If you need to add it manually:

1. Open the project in Xcode
2. Go to **File** > **Add Packages...**
3. Enter the repository URL: `https://github.com/optimizely/swift-sdk.git`
4. Select the latest version and click **Add Package**
5. Ensure the package is added to the "Optimizely-Demo-App" target

### 2. Configure Feature Flag in Optimizely
1. Log in to your Optimizely account
2. Create a feature flag with the key: `demo_feature_flag`
3. Add a **JSON variable** with the key: `allowed_categories`
4. Set the JSON variable value to a JSON object with a `userTypes` array, for example:
   ```json
   {
     "userTypes": ["premium", "gold"]
   }
   ```
   - The `userTypes` array defines which user categories have access to the content
   - Only "premium" and "gold" are in the example, so "silver" users will see the restricted message
   - You can modify this array to include/exclude categories (e.g., add "silver" to grant access)
5. Enable/disable the feature flag as needed for testing

**Note**: 
- Update the `featureFlagKey` constant in `ContentView.swift` if your feature flag key is different from `demo_feature_flag`
- Update the `jsonVariableKey` constant if your JSON variable key is different from `allowed_categories`

### 3. SDK Key
The app is already configured with SDK key: `TfAtdtiXXWjsiiqHH5zHt`

## How It Works

### OptimizelyManager
The `OptimizelyManager` class handles:
- SDK initialization with your SDK key
- Feature flag checking
- JSON variable parsing to extract the array of allowed user categories
- User category access validation

### ContentView
The main view flow:
1. Shows a loading screen while Optimizely initializes
2. Displays the user category selection screen with three buttons
3. When a button is tapped:
   - Retrieves the JSON variable array from Optimizely
   - Checks if the selected category is in the array
   - Shows the appropriate result screen:
     - **Category found**: Welcome message with green checkmark
     - **Category not found**: Restriction message with lock icon
4. Provides a "Back to Selection" button to choose a different category

## Running the App
1. Build and run the app in Xcode
2. The app will automatically:
   - Initialize Optimizely
   - Display the user category selection screen
3. Tap a user category button (Premium, Gold, or Silver)
4. The app will check the Optimizely JSON variable and display the result

## Testing Different Scenarios
- **Add/remove categories in the JSON variable** (e.g., `["premium", "gold", "silver"]`) to grant/revoke access
- **Change the JSON variable array** to test different access scenarios:
  - Only `["premium"]` - only premium users see welcome message
  - `["premium", "gold"]` - premium and gold see welcome, silver sees restriction
  - `["premium", "gold", "silver"]` - all users see welcome message
- **Use the "Back to Selection" button** to test different categories without restarting the app
