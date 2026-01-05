---
title: 🔬 Rik's Laboratory
type: "lab"
layout: "page"
comments: false
aside: false
top_img: false
---

<style>
/* ==================== 全局样式 ==================== */
.lab-container {
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  background: linear-gradient(135deg, #0a0e27 0%, #1a1f3a 100%);
  color: #00ff41;
  padding: 2rem 1rem;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 255, 65, 0.1);
  margin: 2rem auto;
  max-width: 1200px;
  position: relative;
  overflow: hidden;
}

.lab-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    repeating-linear-gradient(
      0deg,
      rgba(0, 255, 65, 0.03) 0px,
      transparent 1px,
      transparent 2px,
      rgba(0, 255, 65, 0.03) 3px
    );
  pointer-events: none;
  animation: scanline 8s linear infinite;
}

@keyframes scanline {
  0% { transform: translateY(0); }
  100% { transform: translateY(100%); }
}

/* ==================== 标题区 ==================== */
.lab-header {
  text-align: center;
  margin-bottom: 3rem;
  padding: 2rem;
  background: rgba(0, 255, 65, 0.05);
  border: 2px solid rgba(0, 255, 65, 0.3);
  border-radius: 8px;
  backdrop-filter: blur(10px);
  position: relative;
}

.lab-header::before,
.lab-header::after {
  content: '▸';
  position: absolute;
  color: #00ff41;
  font-size: 1.5rem;
  animation: blink 1.5s infinite;
}

.lab-header::before {
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
}

.lab-header::after {
  right: 1rem;
  top: 50%;
  transform: translateY(-50%) rotate(180deg);
}

@keyframes blink {
  0%, 49% { opacity: 1; }
  50%, 100% { opacity: 0.3; }
}

.system-status {
  font-size: 1.8rem;
  font-weight: bold;
  letter-spacing: 3px;
  text-shadow: 
    0 0 10px rgba(0, 255, 65, 0.8),
    0 0 20px rgba(0, 255, 65, 0.5),
    0 0 30px rgba(0, 255, 65, 0.3);
  animation: glitch 3s infinite;
}

@keyframes glitch {
  0%, 90%, 100% { 
    text-shadow: 
      0 0 10px rgba(0, 255, 65, 0.8),
      0 0 20px rgba(0, 255, 65, 0.5);
  }
  95% { 
    text-shadow: 
      -2px 0 10px rgba(255, 0, 0, 0.8),
      2px 0 20px rgba(0, 255, 255, 0.8);
  }
}

.cursor-blink {
  animation: cursor-blink 1s step-end infinite;
}

@keyframes cursor-blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

/* ==================== 项目网格 ==================== */
.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

/* ==================== 项目卡片 ==================== */
.project-card {
  background: rgba(10, 14, 39, 0.7);
  border: 1px solid rgba(0, 255, 65, 0.3);
  border-radius: 8px;
  padding: 1.5rem;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.project-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #00ff41, transparent);
  animation: scan 3s infinite;
}

@keyframes scan {
  0% { left: -100%; }
  100% { left: 100%; }
}

.project-card:hover {
  transform: translateY(-5px);
  border-color: #00ff41;
  box-shadow: 
    0 5px 25px rgba(0, 255, 65, 0.3),
    inset 0 0 20px rgba(0, 255, 65, 0.1);
}

.project-card.status-online {
  border-left: 4px solid #00ff41;
}

.project-card.status-coding {
  border-left: 4px solid #ff9500;
}

.project-card.status-stable {
  border-left: 4px solid #00ffff;
}

.project-card.status-offline {
  border-left: 4px solid #666;
  opacity: 0.6;
}

/* ==================== 卡片内容 ==================== */
.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding-bottom: 0.8rem;
  border-bottom: 1px dashed rgba(0, 255, 65, 0.2);
}

.project-title {
  font-size: 1.2rem;
  font-weight: bold;
  color: #00ff41;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.project-status {
  padding: 0.3rem 0.8rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: bold;
  letter-spacing: 1px;
  text-transform: uppercase;
  position: relative;
}

.status-online {
  background: rgba(0, 255, 65, 0.2);
  color: #00ff41;
  border: 1px solid #00ff41;
}

.status-online::before {
  content: '●';
  margin-right: 0.3rem;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}

.status-coding {
  background: rgba(255, 149, 0, 0.2);
  color: #ff9500;
  border: 1px solid #ff9500;
}

.status-coding::before {
  content: '▶';
  margin-right: 0.3rem;
}

.status-stable {
  background: rgba(0, 255, 255, 0.2);
  color: #00ffff;
  border: 1px solid #00ffff;
}

.status-stable::before {
  content: '✓';
  margin-right: 0.3rem;
}

.status-offline {
  background: rgba(102, 102, 102, 0.2);
  color: #999;
  border: 1px solid #666;
}

.status-offline::before {
  content: '○';
  margin-right: 0.3rem;
}

.project-description {
  color: #a0a0a0;
  font-size: 0.9rem;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.project-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1rem;
}

.tag {
  background: rgba(0, 255, 65, 0.1);
  color: #00ff41;
  padding: 0.2rem 0.6rem;
  border-radius: 3px;
  font-size: 0.75rem;
  border: 1px solid rgba(0, 255, 65, 0.3);
}

/* ==================== 响应式设计 ==================== */
@media (max-width: 768px) {
  .projects-grid {
    grid-template-columns: 1fr;
  }
  
  .system-status {
    font-size: 1.2rem;
  }
  
  .lab-container {
    padding: 1rem;
  }
}

/* ==================== 滚动条样式 ==================== */
.lab-container::-webkit-scrollbar {
  width: 8px;
}

.lab-container::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.3);
}

.lab-container::-webkit-scrollbar-thumb {
  background: rgba(0, 255, 65, 0.5);
  border-radius: 4px;
}

.lab-container::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 255, 65, 0.8);
}
</style>

<div class="lab-container">
  <div class="lab-header">
    <div class="system-status">
      > SYSTEM_STATUS: ONLINE<span class="cursor-blink">_</span>
    </div>
  </div>

  <div class="projects-grid">
    <!-- 项目 A: 桌面功放系统 -->
    <div class="project-card status-online">
      <div class="project-header">
        <div class="project-title">🔊 Desktop Audio</div>
        <div class="project-status status-online">Online</div>
      </div>
      <div class="project-description">
        基于 ZK-LT21 芯片的桌面功放系统，集成 IP2326 快充协议与智能电池管理系统 (BMS)。硬件设计已完成 PCB 打样。
      </div>
      <div class="project-tags">
        <span class="tag">ZK-LT21</span>
        <span class="tag">IP2326</span>
        <span class="tag">BMS</span>
        <span class="tag">Hardware</span>
      </div>
    </div>

    <!-- 项目 B: STM32 裸机开发 -->
    <div class="project-card status-coding">
      <div class="project-header">
        <div class="project-title">⚡ STM32 Bare-Metal</div>
        <div class="project-status status-coding">Coding</div>
      </div>
      <div class="project-description">
        纯寄存器级 STM32 开发实践，实现 PWM 波形生成、UART 串口通信，使用逻辑分析仪进行信号调试。拒绝 HAL 库依赖。
      </div>
      <div class="project-tags">
        <span class="tag">Register</span>
        <span class="tag">PWM</span>
        <span class="tag">UART</span>
        <span class="tag">Logic Analyzer</span>
      </div>
    </div>

    <!-- 项目 C: Linux 基础设施 -->
    <div class="project-card status-stable">
      <div class="project-header">
        <div class="project-title">🐧 Linux Infra</div>
        <div class="project-status status-stable">Stable</div>
      </div>
      <div class="project-description">
        基于 Debian 的轻量化网络服务架构，使用 Mihomo 实现代理转发，内存占用优化至 30MB。已稳定运行于生产环境。
      </div>
      <div class="project-tags">
        <span class="tag">Mihomo</span>
        <span class="tag">Debian</span>
        <span class="tag">30MB RAM</span>
        <span class="tag">Optimized</span>
      </div>
    </div>

    <!-- 项目 D: 待定项目 -->
    <div class="project-card status-offline">
      <div class="project-header">
        <div class="project-title">🚀 Next Project</div>
        <div class="project-status status-offline">Planned</div>
      </div>
      <div class="project-description">
        预留项目槽位。未来可能方向：RISC-V 嵌入式开发、Rust 系统编程、FPGA 数字电路设计或其他硬核技术探索。
      </div>
      <div class="project-tags">
        <span class="tag">TBD</span>
        <span class="tag">Future</span>
      </div>
    </div>
  </div>
</div>
