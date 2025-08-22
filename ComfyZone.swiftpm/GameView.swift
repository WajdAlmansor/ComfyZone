import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let scene = MainMenuScene(size: CGSize(width: 3000, height: 3000)) 
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        SpriteKitView(scene: scene)
            .frame(width: 2559, height: 1179) 
            .ignoresSafeArea()
    }
}

struct SpriteKitView: UIViewControllerRepresentable {
    let scene: SKScene
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: 2559, height: 1179)) 
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        viewController.view = skView
        return viewController
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
