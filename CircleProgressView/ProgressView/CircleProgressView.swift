//
//  CircleProgressView.swift
//  CircleProgressView
//
//  Created by 唐超 on 8/15/18.
//  Copyright © 2018 tcc. All rights reserved.
//

import Foundation
import UIKit

class CircleProgressView: UIView {
    
    var progress:CGFloat = 0.0 {
        didSet{
            circleLayer.strokeEnd = progress
            let scoreText = String(format: "%.0f", progress * 100)
            scoreLabel.text = scoreText
            if scoreText.count > 2 {
                scoreLabel.font = UIFont.boldSystemFont(ofSize: 55)
            }
            if progress == 0 {
                stateLabel.text = "无"
            } else if progress <= 0.25 {
                stateLabel.text = "低"
            } else if progress == 0.5 {
                stateLabel.text = "中"
            } else if progress == 0.75 {
                stateLabel.text = "高"
            } else if progress == 1 {
                stateLabel.text = "非常高"
            }
            var bigPoint = false
            for (idx,obj) in pointLayerArray.enumerated(){
                let pointLayer = obj as? CALayer
                pointLayer?.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                if CGFloat(idx) / CGFloat((pointLayerArray.count)) <= progress {
                    pointLayer?.isHidden = false
                } else {
                    if !bigPoint {
                        if idx >= 1 {
                            //最后一个圆点放大
                            let bigpointLayer: CALayer? = pointLayerArray[idx - 1] as? CALayer
                            bigpointLayer?.setAffineTransform(CGAffineTransform(scaleX: 2.0, y: 2.0))
                        }
                        bigPoint = true
                    }
                    pointLayer?.isHidden = true
                }
            }
            
            //三角指示器旋转和改变位置
            
            let angle: CGFloat = progress * 2 * .pi + startOffsetAngle
            triangleLayer.setAffineTransform(CGAffineTransform.identity.rotated(by: angle))
            let triangleCenterX: CGFloat = customCenter.x + trangleRadius * cos(angle)
            let triangleCenterY: CGFloat = customCenter.y + trangleRadius * sin(angle)
            triangleLayer.position = CGPoint(x: triangleCenterX, y: triangleCenterY)
        }
    }
    
    ///进度圆
    private lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        return circleLayer
    }()
    
    ///分数
    private lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel(frame: CGRect.zero)
        return scoreLabel
    }()
    ///评分等级
    private var stateLabel: UILabel!
    ///圆点数组
    private var pointLayerArray: [AnyHashable] = []
    ///三角形指示
    private lazy var triangleLayer: CAShapeLayer = {
        let triangleLayer = CAShapeLayer()
        return triangleLayer
    }()
    
    private var customCenter = CGPoint.zero
    ///起点偏离角度 本来是以最右边为0开始顺时针到2PI的 如果startOffsetAngle=-0.5PI 则为从顶端开始 依次类推
    private var startOffsetAngle: CGFloat = 0.0
    ///三角形指示箭头的半径
    private var trangleRadius: CGFloat = 0.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        backgroundColor = UIColor(red: 31 / 255.0, green: 172 / 255.0, blue: 205 / 255.0, alpha: 1)
        startOffsetAngle = -1.25 * .pi
        //圆的大小
        let rectWidth: CGFloat = 175
        let centerX: CGFloat = bounds.size.width / 2
        let centerY: CGFloat = bounds.size.height / 2
        customCenter = CGPoint(x: centerX, y: centerY)
        let circleRadius: CGFloat = rectWidth / 2.0
        let lineWidth: CGFloat = 3
        
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 70)
        scoreLabel.textAlignment = .center
        scoreLabel.text = "50"
        addSubview(scoreLabel)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: scoreLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: scoreLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        let unitLabel = UILabel(frame: CGRect.zero)
        unitLabel.textColor = UIColor.white
        unitLabel.text = "分"
        unitLabel.font = UIFont.systemFont(ofSize: 16)
        addSubview(unitLabel)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: unitLabel, attribute: .left, relatedBy: .equal, toItem: scoreLabel, attribute: .right, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: unitLabel, attribute: .bottom, relatedBy: .equal, toItem: scoreLabel, attribute: .bottom, multiplier: 1.0, constant: -10.0))
        
        stateLabel = UILabel(frame: CGRect.zero)
        stateLabel.textColor = UIColor.white
        stateLabel.text = "高"
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateLabel)
        addConstraint(NSLayoutConstraint.init(item: stateLabel, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: scoreLabel, attribute: .bottom, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint.init(item: stateLabel, attribute: .centerX, relatedBy: .equal, toItem: scoreLabel, attribute: .centerX, multiplier: 1, constant: 0))
        
        // 创建弧线路径对象
        let fullCirclePath:UIBezierPath = UIBezierPath.init(arcCenter: .init(x: centerX, y: centerY), radius: circleRadius, startAngle: startOffsetAngle, endAngle: 2 * .pi + startOffsetAngle, clockwise: true)
        fullCirclePath.lineCapStyle = .round
        fullCirclePath.lineJoinStyle = .round
        
        //整个圆 底部半透明白圆
        let fullCirclelayer = CAShapeLayer()
        fullCirclelayer.lineCap = kCALineCapButt
        fullCirclelayer.fillColor = UIColor.clear.cgColor
        fullCirclelayer.lineWidth = lineWidth
        fullCirclelayer.strokeColor = UIColor.init(white: 1, alpha: 0.4).cgColor
        fullCirclelayer.path = fullCirclePath.cgPath
        layer.addSublayer(fullCirclelayer)
        
        //全白进度展示圆
        circleLayer.lineCap = kCALineCapButt
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = lineWidth + 1
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.path = fullCirclePath.cgPath
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.1
        layer.addSublayer(circleLayer)
        
    
        let count = 16
        
        for i in 0..<count {
            let radius = circleRadius + 15.0
            let width:CGFloat = 6.0
            let angle = CGFloat(i)/CGFloat(count) * 2.0 * .pi + startOffsetAngle
            let pointCenterX = centerX + radius*cos(angle)
            let pointCenterY = centerY + radius*sin(angle)
            let pointLayer = CALayer()
            pointLayer.frame = .init(x: 0, y: 0, width: width, height: width)
            pointLayer.position = .init(x: pointCenterX, y: pointCenterY)
            pointLayer.backgroundColor = UIColor.white.cgColor
            pointLayer.cornerRadius = width/2;
            pointLayer.masksToBounds = true
            pointLayer.isHidden = true
            pointLayerArray.append(pointLayer)
            layer.addSublayer(pointLayer)
        }
        
        //三角形指示标
        let triangleBezierPath = UIBezierPath()
        let triangleLength: CGFloat = 8
        triangleBezierPath.move(to: CGPoint(x: 0, y: triangleLength / 2))
        triangleBezierPath.addLine(to: CGPoint(x: triangleLength + 2, y: 0))
        triangleBezierPath.addLine(to: CGPoint(x: 0, y: -triangleLength / 2))
        triangleBezierPath.addLine(to: CGPoint(x: 0, y: triangleLength / 2))
        triangleBezierPath.close()
        trangleRadius = circleRadius - triangleLength - 15
        
        triangleLayer.lineCap = kCALineCapSquare
        triangleLayer.fillColor = UIColor.white.cgColor
        triangleLayer.lineWidth = 2
        triangleLayer.strokeColor = UIColor.white.cgColor
        triangleLayer.path = triangleBezierPath.cgPath
        triangleLayer.position = CGPoint(x: centerX + trangleRadius, y: centerY)
        layer.addSublayer(triangleLayer)
    }
    
}

