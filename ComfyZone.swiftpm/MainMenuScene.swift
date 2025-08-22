import SpriteKit

class MainMenuScene: SKScene {
    private var backgroundSound: SKAudioNode!
    private var currentPage = 0 
    private var backgroundImage: SKSpriteNode!
    private var nextButton: SKSpriteNode!
    private var previousButton: SKSpriteNode!
    private var startButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        if backgroundSound == nil {
            if let soundURL = Bundle.main.url(forResource: "backgroundSound", withExtension: "mp3") {
                backgroundSound = SKAudioNode(url: soundURL)
                backgroundSound.autoplayLooped = true
                addChild(backgroundSound)
            }
        }
        
        addBackgroundImage()
        addTitleImage()
        addStartButtonImage()
    }
    
    func addBackgroundImage() {
        backgroundImage = SKSpriteNode(imageNamed: "MainMenuDoor")
        
        let scaleFactor: CGFloat = 0.9
        
        backgroundImage.size = CGSize(width: self.size.width * scaleFactor, 
                                      height: self.size.height * scaleFactor)
        
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = 0
        
        self.addChild(backgroundImage)
    }
    
    func addTitleImage() {
        let titleImage = SKSpriteNode(imageNamed: "NameTitle")
        titleImage.setScale(0.9)
        titleImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 300)
        titleImage.zPosition = 1
        self.addChild(titleImage)
    }
    
    func addStartButtonImage() {
        startButton = SKSpriteNode(imageNamed: "PlayButton")
        startButton.setScale(0.8)
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - -100)
        startButton.zPosition = 1
        startButton.name = "StartButton"
        self.addChild(startButton)
    }
    
    func addNavigationButtons() {
        nextButton?.removeFromParent()
        previousButton?.removeFromParent()
        
        previousButton = SKSpriteNode(imageNamed: "PreviousButton")
        previousButton.setScale(0.1)
        previousButton.position = CGPoint(x: 700, y: 100)
        previousButton.name = "PreviousButton"
        previousButton.zPosition = 1
        self.addChild(previousButton)
        
        if currentPage == 4 {
            nextButton = SKSpriteNode(imageNamed: "Start")
            nextButton.setScale(0.06)
            nextButton.position = CGPoint(x: 1800, y: 95)
            nextButton.name = "StartGameButton"
            nextButton.zPosition = 1
            self.addChild(nextButton)
        } else {
            nextButton = SKSpriteNode(imageNamed: "NextButton")
            nextButton.setScale(0.08)
            nextButton.position = CGPoint(x: 1800, y: 100)
            nextButton.name = "NextButton"
            nextButton.zPosition = 1
            self.addChild(nextButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            for node in touchedNodes {
                if node.name == "StartButton" {
                    showInfoPages()
                } else if node.name == "NextButton" {
                    handleNextButton()
                } else if node.name == "PreviousButton" {
                    handlePreviousButton()
                } else if node.name == "StartGameButton" {
                    startGame()
                }
            }
        }
    }
    
    func showInfoPages() {
        currentPage = 1
        updateSceneForPage()
    }
    
    func handleNextButton() {
        if currentPage < 4 {
            currentPage += 1
            updateSceneForPage()
        } else {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            backgroundSound.removeFromParent()
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    func handlePreviousButton() {
        if currentPage > 1 {
            currentPage -= 1
            updateSceneForPage()
        } else {
            currentPage = 0
            updateSceneForPage()
        }
    }
    
    func updateSceneForPage() {
        self.children.forEach { node in
            if node !== backgroundSound {
                node.removeFromParent()
            }
        }
        
        if currentPage == 0 {
            addBackgroundImage()
            addTitleImage()
            addStartButtonImage()
        } else {
            let imageName: String
            switch currentPage {
            case 1: imageName = "Info1"
            case 2: imageName = "Info2"
            case 3: imageName = "Info3"
            case 4: imageName = "Info4"
            default: imageName = "Info1"
            }
            
            backgroundImage = SKSpriteNode(imageNamed: imageName)
            backgroundImage.size = self.size
            backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            backgroundImage.zPosition = 0
            self.addChild(backgroundImage)
            
            addNavigationButtons()
        }
    }
    
    func startGame() {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        backgroundSound.removeFromParent()
        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
    }
}
