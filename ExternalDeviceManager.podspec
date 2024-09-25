Pod::Spec.new do |s|
  s.name         = 'ExternalDeviceManager'
  s.version      = '1.0.0'
  s.summary      = '监听连接的硬件外设（游戏手柄、键盘、鼠标），处理外设设备的数据输入.'
  s.description  = <<-DESC
                   iOS监听连接的硬件外设（游戏手柄、键盘、鼠标），处理外设设备的数据输入.
                   DESC
  s.homepage     = 'https://github.com/RockyHui'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'RockyHui' => 'linchaohuirocky@gmail.com' }
  s.source       = { :git => 'https://github.com/RockyHui/ExternalDeviceManager.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.{swift}', 'Classes/*/*.{swift}'
  s.platform     = :ios, '13.0'
end