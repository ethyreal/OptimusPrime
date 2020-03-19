//
//  ContentView.swift
//  OptimusPrime
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var store: ObservableStore<AppState, CounterAction>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(store: self.store)) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(store: self.store)) {
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

struct PrimeAlert: Identifiable {
    var id: Int { prime }
    let prime: Int
}

struct CounterView: View {
    
    @ObservedObject var store: ObservableStore<AppState, CounterAction>

    @State var shouldShowPrimeModal: Bool = false
    @State var alertNthPrime: PrimeAlert?
    @State var nthPrimeButtonEnabled: Bool = true
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: { self.store.send(.decrement) }) {
                    Text("-")
                }
                Text("\(self.store.value.count)")
                Button(action: { self.store.send(.increment) }) {
                    Text("+")
                }
            }
            Button(action: { self.shouldShowPrimeModal = true}) {
                Text("Is this prime?")
            }
            Button(action: self.nthPrimeAction) {
                Text("What is th \(ordinal(self.store.value.count)) prime?")
            }.disabled(!self.nthPrimeButtonEnabled)

        }
        .font(.title)
        .navigationBarTitle("Counter Demo")
        .sheet(isPresented: self.$shouldShowPrimeModal) {
            PrimeModalView(store: self.store)
        }
        .alert(item: self.$alertNthPrime) { alert in
            Alert(title: Text("The \(ordinal(self.store.value.count)) prime is \(alert.prime)"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func nthPrimeAction() {
        nthPrimeButtonEnabled = false
        nthPrime(URLSession.shared, self.store.value.count) { result in
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
    
    @ObservedObject var store: ObservableStore<AppState, CounterAction>
    
    var body: some View {
        VStack {
            if isPrime(self.store.value.count) {
                Text("\(self.store.value.count) is prime!")
                if self.store.value.favoritePrimes.contains(self.store.value.count) {
                    Button(action: { self.store.value.favoritePrimes.removeAll(where: { $0 == self.store.value.count })}) {
                        Text("Remove from favorite primes")
                    }
                } else {
                    Button(action: { self.store.value.favoritePrimes.append(self.store.value.count) }) {
                        Text("Save to favorite primes")
                    }
                }
            } else {
                Text("\(self.store.value.count) is not prime :(")
            }
            
            
        }
        .font(.title)
    }
}


//MARK:-

struct FavoritePrimesView: View {
    @ObservedObject var store: ObservableStore<AppState, CounterAction>
    
    var body: some View {
        List {
            ForEach(self.store.value.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                for index in indexSet {
                    self.store.value.favoritePrimes.remove(at: index)
                }
            }
        }
        .navigationBarTitle(Text("Favorite Primes"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: ObservableStore(initialValue: AppState(), reducer: counterReducer))
    }
}



