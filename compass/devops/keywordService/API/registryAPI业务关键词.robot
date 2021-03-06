*** Settings ***
Resource          ../../envInfo/globalEnv.txt
Resource          ../../testData/API/registryAPIData/registryAPIData.txt
#Resource          ../../keywordBasic/API/devopsAPI基础关键词.txt
Library    Collections 
Library    OperatingSystem 
Library    RequestsLibrary



*** Keywords ***
registry_获取仓库
        [Arguments]    ${url}=/v2/registries
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}   
    ${resp}=    get Request    compass    ${url}        headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
registry_添加project
     [Arguments]    ${url}=/v2/registries    ${registryName}=default     
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}  
    ${resp}=    post Request    compass    ${url}/${registryName}/projects      data=${poject_createJSON}  headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
    
registry_删除project
     [Arguments]    ${url}=/v2/registries    ${registryName}=default     ${projectName_l}=${projectName}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}  
    ${resp}=    Delete Request    compass    ${url}/${registryName}/projects/${namespace}_${projectName_l}       headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    204
    
registry_使用dockerfile创建镜像   
    [Arguments]    ${projectName_l}=${projectName}    ${url}=/v2/registries    ${registryName}=default
    ${files_data}    Get Binary File     /root/mygithub/quality/automation/rf/compass/devops/testData/API/registryAPIData/registryTest.tar
    ${header}    Create Dictionary   Content-Type=application/octet-stream  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}  X-Tag=${testImageName}:v1.0     
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}  
    ${resp}=    post Request    compass    ${url}/${registryName}/projects/${namespace}_${projectName_l}/builds    data=${files_data}    headers=${header}     
    Should Be Equal As Strings    ${resp.status_code}    201
    
    
registry_检查镜像 
    [Arguments]    ${testImageName_l}=${testImageName}    ${projectName_l}=${projectName}    ${url}=/v2/registries    ${registryName}=default
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}   
    ${resp}=    get Request    compass    ${url}/${registryName}/projects/${namespace}_${projectName_l}/repositories/${testImageName}        headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    ${result}=    Set Variable    ${content['metadata']['name']}
    Should Be Equal As Strings    ${result}    ${testImageName}    
    log    ${content}

    
registry_使用镜像压缩包创建镜像      
    [Arguments]    ${projectName_l}=${projectName}    ${url}=/v2/registries    ${registryName}=default
    ${files_data}    Get Binary File     /root/mygithub/quality/automation/rf/compass/devops/testData/API/registryAPIData/busybox.tar
    ${header}    Create Dictionary   Content-Type=application/octet-stream  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}  X-Tag=${testImageName}:v1.0     
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}  
    ${resp}=    post Request    compass    ${url}/${registryName}/projects/${namespace}_${projectName_l}/uploads    data=${files_data}    headers=${header}     
    Should Be Equal As Strings    ${resp.status_code}    201
    
    
    
    
    
    