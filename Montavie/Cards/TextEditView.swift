//
//  TextEditView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/14/22.
//

import SwiftUI
import Combine

struct TextEditView: View {
    @Binding var text: String
    @State private var didStartEditing = false
    
    var body: some View {
        TextView(text: $text, didStartEditing: $didStartEditing)
            .onTapGesture {
                didStartEditing = true
            }
    }
}

// from https://www.appcoda.com/swiftui-textview-uiviewrepresentable/
struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var didStartEditing: Bool

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = .clear

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if didStartEditing || text != "" {
            textView.textColor = UIColor.black
            textView.text = text
        }
        else {
            textView.text = "Write something..."
            textView.textColor = UIColor.lightGray
        }

    }

    class Coordinator: NSObject, UITextViewDelegate {
        var control: TextView

        init(_ control: TextView) {
            self.control = control
        }

        func textViewDidChange(_ textView: UITextView) {
            control.text = textView.text
        }
    }

    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct TextEditView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditView(text: .constant("Hello"))
    }
}

