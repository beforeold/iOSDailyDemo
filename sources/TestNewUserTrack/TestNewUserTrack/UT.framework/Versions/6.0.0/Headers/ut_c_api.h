////
//// ut_c_api.h
//// 
//// UserTrack 
//// 开发团队：数据通道团队 
//// UT答疑群：11791581(钉钉) 
//// UT埋点平台答疑群：11779226(钉钉) 
//// 
//// Copyright (c) 2014-2017 Taobao. All rights reserved. 
////
//
//#ifndef ut_c_api_h
//#define ut_c_api_h
//
//#include <stdio.h>
//#include <stdbool.h>
//
//#ifdef __cplusplus
//extern "C" {
//#endif /* __cplusplus */
//
//// 性能埋点表字段名struct
//typedef struct ut_stat_table_field_names {
//    char **col_names;//数组，列字段名列表：注，数组最后需要以NULL结尾，如 {"col1","col2","col3", NULL};
//    char **row_names;//数组，行字段名列表
//    bool is_aggregate;//标记是否提交明细。需要提交明细时设置为false，否则为true
//} ut_stat_table_field_names;
//
//// 性能埋点表内容struct
//typedef struct ut_stat_table_contents {
//    char **col_names;//数组，与ut_stat_table_field_names列字段名列表一一对应
//    char **row_names;//数组，与ut_stat_table_field_names行字段名列表一一对应
//    char **col_values;//数组，与列字段名列表一一对应列值
//    char **row_values;//数组，与列字段名列表一一对应行值
//} ut_stat_table_contents;
//
//// COUNTER
//
///**
// *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
// *  此接口数据量不应太大，
// *
// *  @param module         操作发生所在的页面
// *  @param monitorPoint 监控点名称
// *  @param value        数值
// */
//void ut_counter_commit(const char *module, const char *monitorPoint, double value);
//
///**
// *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
// *  此接口数据量不应太大，
// *
// *  @param module         操作发生所在的页面
// *  @param monitorPoint 监控点名称
// *  @param value        数值
// *  @param arg          附加参数
// */
//void ut_counter_commit_arg(const char *module, const char *monitorPoint, double value, const char *arg);
//
//// ALARM
//
///**
// *  记录业务操作成功接口
// *
// * @param module 模块
// * @param monitorPoint 监控点
// */
//void ut_alarm_commitSuccess(const char *module, const char *monitorPoint);
//
///**
// *  记录业务操作成功接口
// *
// * @param module 模块
// * @param monitorPoint 监控点
// * @arg 附加参数，用于做横向扩展
// */
//void ut_alarm_commitSuccess_arg(const char *module, const char *monitorPoint, const char *arg);
//
///**
// *  记录业务操作失败接口
// *
// * @param module 模块
// * @param monitorPoint 监控点
// * @param errCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
// * @param errMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
// */
//void ut_alarm_commitFail(const char *module, const char *monitorPoint, const char *errCode, const char *errMsg);
//
///**
// *  记录业务操作失败接口
// *
// * @param module 模块
// * @param monitorPoint 监控点
// * @param errCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
// * @param errMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
// * @arg 附加参数，用于做横向扩展
// */
//void ut_alarm_commitFail_arg(const char *module, const char *monitorPoint, const char *errCode, const char *errMsg, const char *arg);
//
//// STAT
//
///**
// * 注册性能埋点
// *
// * @param module 模块
// * @param monitorPoint 监控点
// * @param fieldNames 注册表字段名列表
// */
//void ut_stat_table_register(const char *module, const char *monitorPoint, ut_stat_table_field_names *fieldNames);
//
///**
// * 添加性能埋点的表约束([行]指标)
// *
// * @param name 表字段名
// * @param min 最小约束值
// * @param max 最大约束值
// * @param defaultValue 默认值
// */
//void ut_stat_table_addConstraint(const char *module, const char *monitorPoint, const char *name, double min, double max, double defaultValue);
//
///**
// * 提交性能埋点的表([行]指标)数据
// *
// * @param contents 表数据内容
// */
//void ut_stat_table_commit(const char *module, const char *monitorPoint, ut_stat_table_contents *contents);
//    
//#ifdef __cplusplus
//}
//#endif
//
//#endif /* ut_c_api_h */
