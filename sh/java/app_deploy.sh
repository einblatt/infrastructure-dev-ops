#!/bin/bash

#spring profile
SPRING_PROFILE="-Dspring.profiles.active=prod"

#application name
APP_NAME="xxx.jar"

#jvm params
JVM="-Xms3g -Xmx3g -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

#app log
LOG_FILE="/usr/local/java/app/fundplate/fundplate-business-$(date +%Y-%m-%d).log"

#gc log
GC_CONFIG="-XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintHeapAtGC -XX:+PrintReferenceGC -XX:+PrintGCApplicationStoppedTime -Xloggc:./gc-%t.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=14 -XX:GCLogFileSize=100M"

#remote debug
REMOTE_CONFIG="-Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=n"

#使用说明
function usage() {
    echo "使用说明：sh 脚本名称.sh [start | stop | restart | debug | status]"
    exit 1
}


function is_exist() {
    pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}'`
    # 如果不存在则返回1，存在则返回0
    if [ -z "${pid}" ]; then
    return 1
    else
    return 0
    fi
}

# 启动应用
function start(){
    is_exist
    if [ $? -eq "0" ]; then
    echo "${APP_NAME} is already running. pid=${pid}"
    else
    nohup java ${GC_CONFIG} ${JVM} ${SPRING_PROFILE} -jar ${APP_NAME} >> "$LOG_FILE"  2>&1 &
        echo "${APP_NAME} start success"
    fi
}



# 停止应用
function stop(){
    is_exist
    if [ $? -eq "0" ]; then
    echo "${APP_NAME} shutting down. pid=${pid}"
    kill -9 $pid
    else
    echo "${APP_NAME} is not running"
    fi
}


# 输出应用运行状态
function status(){
    is_exist
    if [ $? -eq "0" ]; then
    echo "${APP_NAME} is running. pid=${pid}"
    else
    echo "${APP_NAME} is not running"
    fi
}


# 重启
function restart(){
    stop
    start
}


# 远程调试Debug模式
function debug() {
    echo " start remote debug mode .........."
    nohup java ${REMOTE_CONFIG} -jar $APP_NAME >/dev/null  2>&1 &
}


# 根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
    "start")
        start
    ;;
    "debug")
        debug
    ;;
    "stop")
        stop
    ;;
    "restart")
    restart
    ;;
    "status")
        status
    ;;
    *)
        usage
    ;;
esac
exit 0
