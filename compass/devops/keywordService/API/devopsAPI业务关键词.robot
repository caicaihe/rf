*** Settings ***
Resource          ../../envInfo/globalEnv.txt
Resource          ../../testData/API/devopsAPIData/devopsAPIData.robot
Resource          ../../keywordBasic/API/devopsAPI基础关键词.robot
Library    Collections 
Library    OperatingSystem 
Library    RequestsLibrary
Library    String



*** Keywords ***
devops_获取workspace
    [Arguments]    ${url}=/v1/workspaces
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header}   
    ${resp}=    get Request    compass    ${url}        headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    [return]    ${content}
    
devops_判断是否已存在workspace
    [Arguments]    ${workspace_name}
    ${result}    Set Variable    ${0}
    ${content}    devops_获取workspace
    ${number}     Set Variable    ${content['metadata']['total']}
     :FOR    ${i}    IN RANGE    ${number}
    \    ${return}    Set Variable    ${content['items'][${i}]['name']}
    \   ${result_tmp}     Run Keyword If    '${return}'=='${workspace_name}'     Set Variable    ${1} 
    \     ...  ELSE        Set Variable    ${0}
    \   ${result}    Evaluate    ${result}+${result_tmp}    
    [return]    ${result}
    
    
    
devops_创建workspace
    [Arguments]    ${repo_type}=github      ${workspaceName}=${workspaceName_github}
    #获取github的token，需要进行base64的解码
    ${githubjson_token}    github流水线获取token    
   ${workspaceJson}     Run Keyword If    '${repo_type}'=='gitlab'   Set Variable    ${workspaceJson_gitlab}
   ...       ELSE IF     '${repo_type}'=='github'   Set Variable      ${githubjson_token}
   ...       ELSE IF     '${repo_type}'=='svn'   Set Variable      ${workspaceJSON_svn}
   log    ${workspaceJson} 
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Post Request    compass    /v1/workspaces      data=${workspaceJson}  headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
devops_删除workspace
    [Arguments]    ${repo_type}=github      ${workspace}=${workspaceName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    delete Request    compass    /v1/workspaces/${workspace}     headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    204
    
    
devops_创建pipeline
    [Arguments]   ${repo_type}=github      ${codeSource}=golang    ${workspace}=${workspaceName_github}     ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Post Request    compass    v1/workspaces/${workspace}/pipelines      data=${pipelineJSON_${repo_type}_${codeSource}}  headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
devops_创建pipeline_push
    [Arguments]   ${repo_type}=github      ${codeSource}=golang    ${workspace}=${workspaceName_github}     ${pipeline}=${pipelineName_github}   ${pushMethod}=tag
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Post Request    compass    v1/workspaces/${workspace}/pipelines      data=${pipelineJSON_${repo_type}_${codeSource}_${pushMethod}}  headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
devops_获取pipeline
    [Arguments]   ${repo_type}=github      ${codeSource}=golang    ${workspace}=${workspaceName_github}     ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Get Request    compass    v1/workspaces/${workspace}/pipelines       headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    
devops_执行pipeline
    [Arguments]    ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Post Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records      data=${recordJSON_${repo_type}}  headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}  
    
devops_pipeline执行结果
    [Arguments]     ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Get Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records       headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    ${result}=    Set Variable    ${content['items'][0]['status']}
    [Return]    ${result} 
 
 devops_pipeline执行结果_流水线执行完毕
    [Arguments]     ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
      :FOR    ${i}    IN RANGE    100
    \    sleep    60
    \    ${return}    devops_pipeline执行结果    ${repo_type}      ${workspace}     ${pipeline}
    \    Run Keyword If    '${return}'=='Success'    Exit For Loop 
    \    Run Keyword If    '${return}'=='Failed'    Exit For Loop
    [Return]    ${return}
    
devops_获取pipeline执行记录
        [Arguments]     ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Get Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records       headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    ${pipeline_id}=    Set Variable    ${content['items'][0]['id']}
    ${task_name}     Set Variable    ${content['items'][0]['stageStatus']['imageBuild']['tasks'][0]['name']}
    log    ${pipeline_id}
    log    ${task_name}
    log    ${content} 
    [return]    ${pipeline_id}    ${task_name} 
    
devops_获取pipeline执行log
     [Arguments]         ${pipeline_id}       ${task_name}  ${stage}=imageBuild     ${repo_type}=github        ${workspace}=${workspaceName_github}    ${pipeline}=${pipelineName_github}  
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    Get Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records/${pipeline_id}/logs?stage=${stage}&task=${task_name}&download=false       headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    200
    #${content}=         Set Variable    ${resp.json()}
    log    ${resp} 
    
    
devops_pipeline获取执行记录ID
    [Arguments]    ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    get Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records      headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    200
    ${content}=         Set Variable    ${resp.json()}
    ${pipelien_log_ID}    Set Variable    ${content['items'][0]['id']}
    log     ${pipelien_log_ID}
    log    ${content} 
    [Return]    ${pipelien_log_ID}

devops_pipeline删除流水线执行记录
    [Arguments]       ${pipelien_log_ID}     ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    delete Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}/records/${pipelien_log_ID}      headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    204

    
 devops_pipeline删除流水线
    [Arguments]        ${repo_type}=github      ${workspace}=${workspaceName_github}      ${pipeline}=${pipelineName_github}
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.devops.caicloud.io    ${header} 
    ${resp}=    delete Request    compass    v1/workspaces/${workspace}/pipelines/${pipeline}      headers=${header}  
    Should Be Equal As Strings    ${resp.status_code}    204
    
devops_删除project
     [Arguments]    ${projectName_l}=${projectName}    ${url}=/v2/registries    ${registryName}=default     
    ${header}    Create Dictionary   Content-Type=application/json  Authorization=Basic YWRtaW46UHdkMTIzNDU2   X-Tenant=${namespace}      
    Create Session    compass  http://${compass_ip}:${api_port}/apis/admin.cargo.caicloud.io    ${header}  
    ${resp}=    Delete Request    compass    ${url}/${registryName}/projects/${namespace}_${projectName_l}       headers=${header}
    Should Be Equal As Strings    ${resp.status_code}    204
    
devops_gitlabpush_tag
    [Arguments]      ${projectID}=2
    ${random}    Generate Random String    8 	[LETTERS]
    ${header}    Create Dictionary    private_token=${gitlab_token}
    Create Session    gitlab  http://${gitlabaddress}/api/v4    ${header}
     ${resp}=    Post Request    gitlab    projects/${projectID}/repository/tags?tag_name=auto${random}&ref=master&private_token=${gitlab_token}    
    Should Be Equal As Strings    ${resp.status_code}    201
    ${content}=         Set Variable    ${resp.json()}
    log    ${content}
    

    
  
    
    