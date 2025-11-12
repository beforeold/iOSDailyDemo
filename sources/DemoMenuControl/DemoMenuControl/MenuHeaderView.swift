import UIKit

class MenuHeaderView: UIView {
    private let slider: UISlider
    private let sliderLabel: UILabel
    private let stepper: UIStepper
    private let stepperLabel: UILabel
    
    var sliderValue: Float {
        get { slider.value }
        set { slider.value = newValue }
    }
    
    var stepperValue: Double {
        get { stepper.value }
        set { stepper.value = newValue }
    }
    
    var onSliderValueChanged: ((Float) -> Void)?
    var onStepperValueChanged: ((Double) -> Void)?
    
    init(frame: CGRect = .zero, initialSliderValue: Float = 0.5, initialStepperValue: Double = 1.0) {
        slider = UISlider()
        sliderLabel = UILabel()
        stepper = UIStepper()
        stepperLabel = UILabel()
        
        super.init(frame: frame)
        
        setupUI()
        slider.value = initialSliderValue
        stepper.value = initialStepperValue
        updateLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 配置 slider label
        sliderLabel.text = "音量"
        sliderLabel.textAlignment = .center
        sliderLabel.font = .systemFont(ofSize: 14, weight: .medium)
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置 slider
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置 stepper label
        stepperLabel.text = "数量"
        stepperLabel.textAlignment = .center
        stepperLabel.font = .systemFont(ofSize: 14, weight: .medium)
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置 stepper
        stepper.minimumValue = 0.0
        stepper.maximumValue = 100.0
        stepper.stepValue = 1.0
        stepper.value = 1.0
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到视图
        addSubview(sliderLabel)
        addSubview(slider)
        addSubview(stepperLabel)
        addSubview(stepper)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // Slider section
            sliderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            sliderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sliderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            slider.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Stepper section
            stepperLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 16),
            stepperLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stepperLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stepper.topAnchor.constraint(equalTo: stepperLabel.bottomAnchor, constant: 8),
            stepper.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        // 设置背景色
        backgroundColor = .systemBackground
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateLabels()
        onSliderValueChanged?(sender.value)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        updateLabels()
        onStepperValueChanged?(sender.value)
    }
    
    private func updateLabels() {
        let percentage = Int(slider.value * 100)
        sliderLabel.text = "音量: \(percentage)%"
        
        let stepperInt = Int(stepper.value)
        stepperLabel.text = "数量: \(stepperInt)"
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 140)
    }
}


