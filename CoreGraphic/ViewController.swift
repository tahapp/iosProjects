//
//  ViewController.swift
//  27 Core Graphic
//
//  Created by Taha Saleh on 1/8/23.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    let canvasSize = CGSize(width: 512, height: 512)
    var currentDrawType = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    
    @IBAction func redraw(_ sender: UIButton)
    {
        currentDrawType  = (currentDrawType + 1) % 7
        
        switch (currentDrawType)
        {
        case 0 :
            drawRectangle()
        case 1:
            drawElipse()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        default:
            break
        }
    }
    
    func drawRectangle()
    {
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
      
        let image = renderer.image{
            (context) in
            
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 20, dy: 20)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
          
            context.cgContext.addRect(rect)
            
            context.cgContext.drawPath(using: .fillStroke)
           
        }
        
        imageView.image = image
    }
    
    func drawElipse()
    {
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
       
        let image = renderer.image{
            (context) in
            
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 20, dy: 20)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
          
            context.cgContext.addEllipse(in:rect)
            
            
            context.cgContext.drawPath(using: .fillStroke)
           
        }
        
        imageView.image = image
    }
    
    func drawCheckerBoard()
    {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let image = renderer.image{
            (context) in
         
            for n in 0..<8
            {
                for j in 0..<8
                {
                    if (n + j) % 2 == 0
                    {
                        
                        context.cgContext.fill(CGRect(x: j * 64, y: n * 64, width: 64, height: 64))
                    }

                }
                
            }
        }
        imageView.image = image
    }
    func drawRotatedSquares()
    {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let image = renderer.image{(context) in
            context.cgContext.translateBy(x: 256, y: 256)
            let rotations = 32
            let moves = CGFloat.pi * 2 / CGFloat(rotations)
            
            for _ in 0..<rotations
            {
                context.cgContext.rotate(by: moves)
                /*  this is an accumaltive process, meaning the rotation
                 will be applied to whatever was or will be drawn on the canvas*/
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                //context.cgContext.stroke()
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
            //context.cgContext.drawPath(using: .stroke)
            
        }
        
        imageView.image = image
    }
    func drawLines()
    {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let image = renderer.image{
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var isFirst = true
            var lenght = 256.0
            
            for _ in  0..<256
            {
                ctx.cgContext.rotate(by: .pi / 2)
                /* in a loop how to say, if its the first time,
                 do something, then the rest is ...*/
                if isFirst
                {
                    ctx.cgContext.move(to: .init(x: lenght, y: 50))
                    isFirst = false
                }else
                {
                    ctx.cgContext.addLine(to: .init(x: lenght, y: 50))
                    
                }
                lenght *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        self.imageView.image = image
    }
    func drawImagesAndText()
    {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let image = renderer.image{
            ctx in
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let attr : [NSAttributedString.Key:Any] = [
                .font : UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraph
            ]
            let string = " who ever wants to be higher in position, he should stay all night"
            
            let attriString = NSAttributedString(string: string, attributes: attr)
            attriString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            //usesLineFragmentOrigin wraps lines more easily
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        self.imageView.image = image
    }
    
}

