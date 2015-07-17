
import SpriteKit

class ViewController: UIViewController {
  @IBOutlet weak var skView: SKView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsDrawCount = true
  }

  override func viewWillLayoutSubviews()  {
    super.viewWillLayoutSubviews()
    
    if skView.scene == nil {
      let scene = MyScene(size: skView.bounds.size)
      skView.presentScene(scene)
    }
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  override func shouldAutorotate() -> Bool {
    return true
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Landscape
  }
}
