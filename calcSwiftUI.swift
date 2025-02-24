import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentOperation: String? = nil
    @State private var previousNumber: Double = 0

    // Define the layout for calculator buttons
    let buttons: [[String]] = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // Display Screen
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .background(Color.black)
            
            // Buttons Grid
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button)
                                .font(.title)
                                .frame(width: self.buttonSize(), height: self.buttonSize())
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(self.buttonSize() / 2)
                        }
                    }
                }
            }
        }
        .padding(.bottom)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    // Calculate button dimensions dynamically
    func buttonSize() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    // Logic to handle button taps
    func buttonTapped(_ symbol: String) {
        switch symbol {
        // If the symbol is a digit or a decimal point
        case "0"..."9", ".":
            if display == "0" {
                display = symbol
            } else {
                display += symbol
            }
            
        // For operations: save the current display value and the operation
        case "+", "-", "x", "/":
            currentOperation = symbol
            previousNumber = Double(display) ?? 0
            display = "0"
            
        // When "=" is tapped, perform the calculation
        case "=":
            let current = Double(display) ?? 0
            var result: Double = 0
            if let operation = currentOperation {
                switch operation {
                case "+":
                    result = previousNumber + current
                case "-":
                    result = previousNumber - current
                case "x":
                    result = previousNumber * current
                case "/":
                    result = previousNumber / current
                default:
                    break
                }
                // Format the result to remove trailing zeros
                if result.truncatingRemainder(dividingBy: 1) == 0 {
                    display = String(Int(result))
                } else {
                    display = String(result)
                }
                currentOperation = nil
            }
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
