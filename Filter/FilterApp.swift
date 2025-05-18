//
//  FilterApp.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 03/05/25.
//

import SwiftUI

@main
struct FilterApp: App {
    @AppStorage("isFirstTimeLaunch") var isFirstTimeLaunch: Bool = true
    
    @StateObject private var router = AppRouter()
    
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
        .modelContainer(Container.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
    
    // Handle app intent routing
    func handleDeepLink(_ url: URL) {
        guard url.scheme == "filterapp",
              url.host == "menu",
              let menuId = url.pathComponents.dropFirst().first else { return }
        
        DispatchQueue.main.async {
            self.router.selectedMenuId = menuId
        }
    }
}

// Router: save menuId & trigger navigation
class AppRouter: ObservableObject {
    @Published var selectedMenuId: String? = nil
}

// Set up navigation from root
struct RootView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack {
            ContentView()
                .navigationDestination(isPresented: Binding<Bool>(
                    get: { router.selectedMenuId != nil },
                    set: { if !$0 { router.selectedMenuId = nil } }
                )) {
                    if let id = router.selectedMenuId {
                        DetailView(menuId: id)
                    }
                }
        }
        .tint(Color.sageGreen)
    }
}
