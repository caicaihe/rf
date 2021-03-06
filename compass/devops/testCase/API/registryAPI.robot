*** Settings ***
Resource    ../../keywordService/API/registryAPI业务关键词.txt
Resource          ../../envInfo/globalEnv.txt

*** Test Cases ***    
registry_dockerfile上传测试
    log      registry_添加project
    registry_添加project
    log    registry_使用dockerfile创建镜像
    registry_使用dockerfile创建镜像    
    log    registry_检查镜像
    registry_检查镜像        ${testImageName}
    log      registry_删除project
    registry_删除project
    
    
registry_镜像上传测试
    log      registry_添加project
    registry_添加project
    log    registry_使用镜像压缩包创建镜像  
    registry_使用镜像压缩包创建镜像    
    log    registry_检查镜像
    registry_检查镜像        busybox
    log      registry_删除project
    registry_删除project