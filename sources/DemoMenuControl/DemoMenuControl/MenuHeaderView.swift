import UIKit

class MenuHeaderView: UIView {
    private let slider: UISlider
    private let label: UILabel
    
    var value: Float {
        get { slider.value }
        set { slider.value = newValue }
    }
    
    var onValueChanged: ((Float) -> Void)?
    
    init(frame: CGRect = .zero, initialValue: Float = 0.5) {
        slider = UISlider()
        label = UILabel()
        
        super.init(frame: frame)
        
        setupUI()
        slider.value = initialValue
        updateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 配置 label
        label.text = "音量"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置 slider
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到视图
        addSubview(label)
        addSubview(slider)
        
        // 设置约束
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            slider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        // 设置背景色
        backgroundColor = .systemBackground
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateLabel()
        onValueChanged?(sender.value)
    }
    
    private func updateLabel() {
        let percentage = Int(slider.value * 100)
        label.text = "音量: \(percentage)%"
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 80)
    }
}

