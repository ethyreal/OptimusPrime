//
//  ContentView.swift
//  OptimusPrime
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var state: AppState
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(state: self.state)) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(state: self.state)) {
                    Text("Favorite primes")
                }
            }.navigationBarTitle("State Management")
        }
    }
}

private func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

class AppState: ObservableObject {
    @Published var count: Int = 0
    
    @Published var favoritePrimes: [Int] = []
}

struct PrimeAlert: Identifiable {
    var id: Int { prime }
    let prime: Int
}

struct CounterView: View {
    
    @ObservedObject var state: AppState

    @State var shouldShowPrimeModal: Bool = false
    @State var alertNthPrime: PrimeAlert?
    @State var nthPrimeButtonEnabled: Bool = true
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: { self.state.count -= 1}) {
                    Text("-")
                }
                Text("\(self.state.count)")
                Button(action: { self.state.count += 1}) {
                    Text("+")
                }
            }
            Button(action: { self.shouldShowPrimeModal = true}) {
                Text("Is this prime?")
            }
            Button(action: self.nthPrimeAction) {
                Text("What is th \(ordinal(self.state.count)) prime?")
            }.disabled(!self.nthPrimeButtonEnabled)

        }
        .font(.title)
        .navigationBarTitle("Counter Demo")
        .sheet(isPresented: self.$shouldShowPrimeModal) {
            PrimeModalView(state: self.state)
        }
        .alert(item: self.$alertNthPrime) { alert in
            Alert(title: Text("The \(ordinal(self.state.count)) prime is \(alert.prime)"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func nthPrimeAction() {
        nthPrimeButtonEnabled = false
        nthPrime(URLSession.shared, self.state.count) { result in
            self.nthPrimeButtonEnabled = true
            let prime = try? result.get()
            self.alertNthPrime = prime.map(PrimeAlert.init)
        }
    }
}

private func isPrime(_ num: Int) -> Bool {
    if num <= 1 { return false }
    if num <= 3 { return true }
    for i in 2...Int(sqrtf(Float(num))) {
        if num % i == 0 { return false }
    }
    return true
}

struct PrimeModalView: View {
    
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if isPrime(self.state.count) {
                Text("\(self.state.count) is prime!")
                if self.state.favoritePrimes.contains(self.state.count) {
                    Button(action: { self.state.favoritePrimes.removeAll(where: { $0 == self.state.count })}) {
                        Text("Remove from favorite primes")
                    }
                } else {
                    Button(action: { self.state.favoritePrimes.append(self.state.count) }) {
                        Text("Save to favorite primes")
                    }
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
            
            
        }
        .font(.title)
    }
}


//MARK:-

struct FavoritePrimesView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        List {
            ForEach(self.state.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                for index in indexSet {
                    self.state.favoritePrimes.remove(at: index)
                }
            }
        }
        .navigationBarTitle(Text("Favorite Primes"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: AppState())
    }
}



