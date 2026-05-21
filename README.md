
<br />
<div align="center">

<h3 align="center">基础服务部署指南</h3>

  <p align="center">
    快速容器化部署基础服务
  </p>
</div>



<!-- GETTING STARTED -->
## Getting Started

请按照以下步骤完成基础服务的通用部署

### 1. 安装Docker 

进入sh目录,运行`install_docker.sh`脚本

### 2. 安装ACME
进入acme目录,运行`install_acme.sh`脚本

### 3. 初始化服务部署脚本
进入sh目录,运行`init_dir.sh`,此脚本会将dev-ops/docker下的所有服务部署文件复制到/usr/local/docker中

### 4. 部署服务
根据自身业务需求部署相应服务,进入/usr/local/docker下的对应服务中,执行`docker-compose up -d`命令