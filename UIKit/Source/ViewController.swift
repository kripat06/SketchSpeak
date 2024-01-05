//
//  Created by Krish Patel on 4/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            CustomController()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad (9th generation)")
    }
}

struct CustomController : UIViewControllerRepresentable{
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomController>) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Base")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomController>) {
    }
}
