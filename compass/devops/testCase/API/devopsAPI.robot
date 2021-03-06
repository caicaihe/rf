*** Settings ***
Resource    ../../keywordService/API/devopsAPI业务关键词.robot
Resource          ../../envInfo/globalEnv.robot

*** Test Cases ***    
devops_持续交付_gitlab_golang流水线
    log    环境初始化
    ${result}    devops_判断是否已存在workspace    ${workspaceName_gitlab}
     Run Keyword If    ${result}==${1}    devops_删除workspace    gitlab   ${workspaceName_gitlab} 
    log   devops_创建workspace
    devops_创建workspace    gitlab   
    log    devops_获取workspace
     devops_获取workspace
     log     devops_创建pipeline
     devops_创建pipeline   gitlab   golang   ${workspaceName_gitlab}       ${pipelineName_github}
     log    devops_获取pipeline
     devops_获取pipeline    gitlab    golang    ${workspaceName_gitlab}
     log    devops_执行pipeline
    devops_执行pipeline     gitlab      ${workspaceName_gitlab}     ${pipelineName_gitlab}
    log    等待devops_pipeline执行结果
    ${return}    devops_pipeline执行结果_流水线执行完毕    gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}
    log    断言执行结果为success
    Run Keyword And Continue On Failure    Should Be Equal As Strings    '${return}'    'Success'   
    log     devops_获取pipeline执行记录
     ${pipeline_id}    ${task_name}     devops_获取pipeline执行记录     gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}  
    log     devops_获取pipeline执行log
     devops_获取pipeline执行log  ${pipeline_id}   ${task_name}  imageBuild    gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}      
    log    删除流水线组
    devops_删除workspace    gitlab   ${workspaceName_gitlab} 
    log    devops_删除project
    devops_删除project     ${workspaceName_gitlab}
    
 
    
devops_持续交付_github_maven流水线_加速
    log    环境初始化
    ${result}    devops_判断是否已存在workspace    ${workspaceName_github}
     Run Keyword If    ${result}==${1}    devops_删除workspace    github   ${workspaceName_github} 
    log    devops_创建workspace
    devops_创建workspace    github    ${workspaceName_github}  
    log    devops_获取workspace
     devops_获取workspace
    log     devops_创建pipeline    
    devops_创建pipeline    github    maven    ${workspaceName_github}     ${pipelineName_github}
    log    devops_获取pipeline
     devops_获取pipeline    github    maven    ${workspaceName_github}
    log    devops_执行pipeline
    devops_执行pipeline    github   ${workspaceName_github}     ${pipelineName_github}
    log    等待devops_pipeline执行结果
    ${return}    devops_pipeline执行结果_流水线执行完毕   github   ${workspaceName_github}     ${pipelineName_github} 
    log    断言执行结果为success
    Run Keyword And Continue On Failure    Should Be Equal As Strings    '${return}'    'Success'   
    log     devops_获取pipeline执行记录
    ${pipeline_id}    ${task_name}     devops_获取pipeline执行记录     github   ${workspaceName_github}     ${pipelineName_github}  
    log     devops_获取pipeline执行log
     devops_获取pipeline执行log  ${pipeline_id}   ${task_name}  imageBuild    github   ${workspaceName_github}     ${pipelineName_github}  
    log    删除流水线组
    devops_删除workspace   github   ${workspaceName_github}  
     log    devops_删除project
    devops_删除project     ${workspaceName_github} 
    
        
devops_持续交付_svn_golang流水线
     log    环境初始化
    ${result}    devops_判断是否已存在workspace    ${workspaceName_svn}
     Run Keyword If    ${result}==${1}    devops_删除workspace    svm   ${workspaceName_svn} 
    log    devops_创建workspace
    devops_创建workspace    svn    ${workspaceName_svn}  
    log    devops_获取workspace
     devops_获取workspace
     log     devops_创建pipeline
     devops_创建pipeline   svn   golang   ${workspaceName_svn}       ${pipelineName_svn}
     log    devops_获取pipeline
     devops_获取pipeline    svn    golang    ${workspaceName_svn}     ${pipelineName_svn}
      log    devops_执行pipeline
    devops_执行pipeline    svn   ${workspaceName_svn}     ${pipelineName_svn}
    log    等待devops_pipeline执行结果
    ${return}    devops_pipeline执行结果_流水线执行完毕   svn   ${workspaceName_svn}     ${pipelineName_svn} 
    log    断言执行结果为success
    Run Keyword And Continue On Failure    Should Be Equal As Strings    '${return}'    'Success' 
    log     devops_获取pipeline执行记录
    ${pipeline_id}    ${task_name}     devops_获取pipeline执行记录     svn   ${workspaceName_svn}     ${pipelineName_svn}  
    log     devops_获取pipeline执行log
     devops_获取pipeline执行log  ${pipeline_id}   ${task_name}  imageBuild    svn   ${workspaceName_svn}     ${pipelineName_svn}   
    log    获取流水线执行记录ID
    ${pipelien_log_ID}    devops_pipeline获取执行记录ID    svn   ${workspaceName_svn}     ${pipelineName_svn}
    log    删除流水线执行记录
    devops_pipeline删除流水线执行记录       ${pipelien_log_ID}     svn   ${workspaceName_svn}     ${pipelineName_svn} 
    log    删除流水线
    devops_pipeline删除流水线       svn   ${workspaceName_svn}     ${pipelineName_svn}
    log    删除流水线组
    devops_删除workspace   svn   ${workspaceName_svn}   
     log    devops_删除project
    devops_删除project     ${workspaceName_svn}
    
    
devops_持续交付_gitlab_golang流水线tag触发
    log    环境初始化
    ${result}    devops_判断是否已存在workspace    ${workspaceName_gitlab}
     Run Keyword If    ${result}==${1}    devops_删除workspace    gitlab   ${workspaceName_gitlab} 
    log   devops_创建workspace
    devops_创建workspace    gitlab   
    log    devops_获取workspace
     devops_获取workspace
     log     devops_创建pipeline
     devops_创建pipeline_push   gitlab   golang   ${workspaceName_gitlab}       ${pipelineName_github}   tag
     log    devops_获取pipeline
     devops_获取pipeline    gitlab    golang    ${workspaceName_gitlab}
     log    gitlab添加tag
    devops_gitlabpush_tag
    log    等待devops_pipeline执行结果
    ${return}    devops_pipeline执行结果_流水线执行完毕    gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}
    log    断言执行结果为success
    Run Keyword And Continue On Failure    Should Be Equal As Strings    '${return}'    'Success'   
    log     devops_获取pipeline执行记录
     ${pipeline_id}    ${task_name}     devops_获取pipeline执行记录     gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}  
    log     devops_获取pipeline执行log
     devops_获取pipeline执行log  ${pipeline_id}   ${task_name}  imageBuild    gitlab   ${workspaceName_gitlab}     ${pipelineName_gitlab}      
    log    删除流水线组
    devops_删除workspace    gitlab   ${workspaceName_gitlab} 
    log    devops_删除project
    devops_删除project     ${workspaceName_gitlab}
   
