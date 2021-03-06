*** Settings ***
Resource          ../../envInfo/globalEnv.robot
Resource          ../../testData/API/devopsAPIData/devopsAPIData.robot
Library    Collections 
Library    OperatingSystem 
Library    String


*** Keywords ***
github流水线获取token
    ${kk}    Evaluate    base64.b64decode('${github_token}')    modules=base64
    ${kkstr}     Decode Bytes To String    ${kk}    UTF-8
    log    ${kk}
    ${github_decode_token}    Evaluate    ${workspaceJSON_github}
    Set To Dictionary    ${github_decode_token['scm']}      token=${kkstr}
    log     ${github_decode_token['scm']['token']}
    [Return]    ${github_decode_token}