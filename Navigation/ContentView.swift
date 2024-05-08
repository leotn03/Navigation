//
//  ContentView.swift
//  Navigation
//
//  Created by Leo Torres Neyra on 17/1/24.
//

import SwiftUI

struct Student: Hashable{
    var id = UUID()
    var name: String
    var age: Int
}

struct HandlingNavigationView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink ("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
            .navigationDestination(for: Student.self) { student in
                Text("You selected \(student.name)")
            }
        }
    }
}

struct ProgmamaticNavigationView: View {
    @State private var path = [Int]()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Show 32") {
                    path = [32]
                }
                
                Button("Show 64") {
                    path.append(64)
                }
                
                Button("Show 32 then 64") {
                    path = [32, 64]
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

struct NavigationPathView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach (0..<5) { i in
                    NavigationLink("Selected Number: \(i)", value: i)
                }
                
                ForEach (0..<5) { i in
                    NavigationLink("Selected String: \(i)", value: String(i))
                }
            }
            .toolbar {
                Button("Push 556") {
                    path.append(556)
                }
                
                Button("Push Hello") {
                    path.append("Hello")
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
        }
    }
}

struct DetailView: View {
    var number: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink("Go to random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .toolbar {
                Button("Home") {
                    path = NavigationPath()
                }
            }
    }
}

struct NavigationToRootView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            DetailView(number: 0, path: $path)
                .navigationDestination(for: Int.self) {i in
                    DetailView(number: i, path: $path)
                }
        }
    }
}

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        
        path = NavigationPath()
    }
    
    func save() {
        guard let representation = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct DetailView2: View {
    var number: Int
    var body: some View {
        NavigationLink ("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct NavigationPathCodableView : View {
    @State private var pathStore = PathStore()
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView2(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView2(number: i)
                }
        }
    }
}

/**
 * Muestra tecnicas para cambiar el diseño de la barra de navegación y la toolbar
 */
struct ContentView: View {
    @State private var title = "SwiftUI"
    
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                Text("Row \(i)")
            }
            /** Combinado con navigationBarTitleDisplayMode en .inline, muestra una flecha que abre la opción de cambiar el titulo */
            .navigationTitle($title)
            /** Muestra en medio y en pequeño el titulo */
            .navigationBarTitleDisplayMode(.inline)
            /** Muestra el fondo en azul del titulo de la barra de navegation */
            .toolbarBackground(.blue)
            /** Cambia el color de esquema */
            .toolbarColorScheme(.dark)
            /** Esconde la toolbar de la barra de navegación */
            //.toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup (placement: .topBarLeading) {
                    Button ("Tap") { /* button action code */ }
                    
                    Button ("Tap Me") { /* button action code*/ }
                }
                
                ToolbarItem (placement: .confirmationAction) {
                    Button("Or Tap Me") { }
                }
            }
            /** Para esconder el butón de ir atrás */
            //.navigationBarBackButtonHidden()
            
        }
    }
}

#Preview {
    HandlingNavigationView()
    //ProgmamaticNavigationView()
    //NavigationPathView()
    //NavigationToRootView()
    //NavigationPathCodableView()
    //ContentView()
}
